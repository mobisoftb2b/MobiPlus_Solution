using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Web.UI.HtmlControls;
using System.Globalization;
using System.Threading;

public partial class Pages_Main_Home : PageBaseCls
{
    public string FormiD = "0";
    public string isToHideHedders = "False";
    public string Lang = "";
    private string MenuSelectedItem
    {
        get
        {
            if (Session["MenuSelectedItem"] == null)
                Session["MenuSelectedItem"] = "sm_0";
            return Session["MenuSelectedItem"].ToString();
        }
        set
        {
            Session["MenuSelectedItem"] = value;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        Lang = SessionLanguage;

        if (!IsPostBack)
        {
            if (Request.QueryString["SelectedMenuItem"] != null)
                MenuSelectedItem = Request.QueryString["SelectedMenuItem"].ToString();
            init();
            hdnIsFirstLoad.Value = "true";
            initFilters();
        }
    }
    protected void btnSetMenuSelectedItem_Click(object sender, EventArgs e)
    {
        MenuSelectedItem = hdnMenuSelectedItem.Value;
    }
    protected void btnIniFilters_Click(object sender, EventArgs e)
    {
        initFilters();
    }
    private void init()
    {
        string htm = "";
        MPLayoutService wr = new MPLayoutService();
        DataTable dt = wr.MPLayout_GetProfileData(ProfileID, SessionVersionID, ConStrings.DicAllConStrings[SessionProjectName]);

        if (Request.QueryString["FormID"] != null)
        {
            DataTable dtPr = wr.MPLayout_GetUserProfileByLang(SessionUserID, SessionLanguage, Request.QueryString["FormID"].ToString(), ConStrings.DicAllConStrings[SessionProjectName]);
            if (dtPr == null || (dtPr != null && dtPr.Rows.Count == 0))
                Response.Redirect("~/Login.aspx?dtPr=" + dtPr.Rows.Count);
        }
        if (dt != null)
        {
            FormiD = "0";
            if (Request.QueryString["FormID"] == null)
            {
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    if (FormiD != dt.Rows[i]["FormID"].ToString())
                    {
                        FormiD = dt.Rows[i]["FormID"].ToString();
                    }
                }
            }
            else
            {
                FormiD = Request.QueryString["FormID"].ToString();
                if (Request.QueryString["IsAllPage"] != null && Request.QueryString["IsAllPage"].ToString() == "true")
                    isToHideHedders = "True";
            }
            //menu
            if (dt.Rows.Count > 0 && dt.Rows[0]["MenuID"].ToString() != "")
            {

                htm = GetMenuOneItems(dt.Rows[0]["MenuID"].ToString(), false);

                ScriptManager.RegisterClientScriptBlock(this.Page, typeof(Page), "jkey1", "SetMenuName(\"" + dt.Rows[0]["MenuName"].ToString() + "\");SetMenu('" + htm + "');", true);

            }
        }
    }
    int counter = 0;

    private int counyter
    {
        get
        {
            if (ViewState["counyter"] == null)
                ViewState["counyter"] = 0;
            return (int)ViewState["counyter"];
        }
        set
        {
            ViewState["counyter"] = value;
        }
    }
    private string OldMenuID = "";
    private string GetMenuOneItems(string MenuID, bool isSubMenu)
    {
        counter++;
        if (counter > 1105)
        {
            return "";
        }
        string htm = "";

        MPLayoutService wr = new MPLayoutService();
        if (OldMenuID != MenuID)
        {
            OldMenuID = MenuID;
            DataTable dtMenuItems = wr.Layout_GetMenuItemsDT(MenuID, ConStrings.DicAllConStrings[SessionProjectName]);


            //htm = "<ul  id=\"menu\" class=\"menu\" style=\"z-index: 1111;\">";
            //if (counter > 1)
            //    htm = "<ul  id=\"inner\" class=\"inner\" style=\"z-index: 2222;\">";
            //for (int i = 0; i < dtMenuItems.Rows.Count; i++)
            //{
            //    if (dtMenuItems.Rows[i]["ZoomObjTypeID"].ToString() != "3")// !menu
            //    {
            //        if (dtMenuItems.Rows[i]["ImgID"].ToString() == "")
            //            htm += "<li ><a class=\"aMenu\" href=\"Home.aspx?FormID=" + dtMenuItems.Rows[i]["ZoomObjectID"].ToString() + "\"><div style=\"float:right\">&nbsp;</div>" + dtMenuItems.Rows[i]["Description"].ToString() + "</a></li>";
            //        else
            //            htm += "<li ><a class=\"aMenu\" href=\"Home.aspx?FormID=" + dtMenuItems.Rows[i]["ZoomObjectID"].ToString() + "\"><div style=\"float:right\"><img src=\"../../Handlers/ShowImage.ashx?id=" + dtMenuItems.Rows[i]["ImgID"].ToString() + "\" width=\"16px\"/></div>" + dtMenuItems.Rows[i]["Description"].ToString() + "</a></li>";
            //    }
            //    else//menu
            //    {
            //        if (dtMenuItems.Rows[i]["ImgID"].ToString() == "")
            //            htm += "<li><a class=\"aMenu\" href=\"#\"><div style=\"float:right\">&nbsp;</div><table cellpadding=\"0\" cellspacing=\"0\" style=\"white-space:nowrap;\"><tr><td>" + dtMenuItems.Rows[i]["Description"].ToString() + "</td><td style=\"width:100%;\">&nbsp;</td><td>></td></tr></table></a>";
            //        else
            //            htm += "<li><a class=\"aMenu\" href=\"#\"><div style=\"float:right\"><img src=\"../../Handlers/ShowImage.ashx?id=" + dtMenuItems.Rows[i]["ImgID"].ToString() + "\" width=\"16px\"/></div><table cellpadding=\"0\" cellspacing=\"0\" style=\"white-space:nowrap;\"><tr><td>" + dtMenuItems.Rows[i]["Description"].ToString() + "</td><td style=\"width:100%;\">&nbsp;</td><td>></td></tr></table></a>";

            //        htm += GetMenuOneItems(dtMenuItems.Rows[i]["ZoomObjectID"].ToString());
            //        htm += "</li>";
            //    }

            //}
            //htm += "</ul>";
            //if (!isSubMenu)
            htm += "<table cellpadding=\"0\" cellspacing=\"0\" width=\"99%\">";

            string Params = "";

            string[] arKeys = Request.QueryString.AllKeys;
            for (int i = 0; i < Request.QueryString.Count; i++)
            {
                if (arKeys[i] != "Width" && arKeys[i] != "Height" && arKeys[i] != "WinID" && arKeys[i] != "ID")
                    Params += arKeys[i] + "=" + Request.QueryString[i] + ";";
            }

            for (int i = 0; i < dtMenuItems.Rows.Count; i++)
            {
                string className = "sm ";

                if (MenuSelectedItem == "sm_" + counyter.ToString())
                    className = "smSelected";

                string SubClassName = "p3 p2";

                if (MenuSelectedItem == "sm_" + counyter.ToString())
                    SubClassName = "smSelected" + " p4";

                string TextSubClassName = "p3";

                if (MenuSelectedItem == "sm_" + counyter.ToString())
                    TextSubClassName = "p5";

                string MainClassName = "p3";

                if (MenuSelectedItem == "sm_" + counyter.ToString())
                    MainClassName = "p6";



                htm += "<tr class=\"MItem\">";

                string RowOpenReport = "";
                string RowOpenForm = "";


                if (dtMenuItems.Rows[i]["ZoomObjTypeID"].ToString() == "2"/*report*/ && dtMenuItems.Rows[i]["ZoomObjectID"].ToString() != "")
                {
                    RowOpenReport = dtMenuItems.Rows[i]["ZoomObjectID"].ToString();
                    htm += "<td id=\"sm_" + counyter.ToString() + "\" colspan=\"2\" class=\"" + className + "\" onclick=SetMenuSelectedItenm(\"sm_" + counyter.ToString() + "\");openNewReport3(\"" + RowOpenReport + "\",\"" + Params + "\");>";
                }
                else if (dtMenuItems.Rows[i]["ZoomObjTypeID"].ToString() == "1"/*CompileActivities*/ && dtMenuItems.Rows[i]["ZoomObjectID"].ToString() != "")
                {
                    RowOpenReport = dtMenuItems.Rows[i]["ZoomObjectID"].ToString();
                    htm += "<td id=\"sm_" + counyter.ToString() + "\" colspan=\"2\" class=\"" + className + "\" onclick=SetMenuSelectedItenm(\"sm_" + counyter.ToString() + "\");openNewReport3(\"" + RowOpenReport + "\",\"" + Params + "\");>";
                }
                else if (dtMenuItems.Rows[i]["ZoomObjTypeID"].ToString() == "5"/*form*/ && dtMenuItems.Rows[i]["ZoomObjectID"].ToString() != "")
                {
                    RowOpenForm = dtMenuItems.Rows[i]["ZoomObjectID"].ToString();
                    htm += "<td id=\"sm_" + counyter.ToString() + "\" colspan=\"2\" class=\"" + className + "\" onclick=SetMenuSelectedItenm(\"sm_" + counyter.ToString() + "\");openNewForm3(" + RowOpenForm + ",\"" + Params + "\");>";
                }
                else
                {
                    RowOpenReport = "0";
                    htm += "<td id=\"sm_" + counyter.ToString() + "\" colspan=\"2\" class=\"" + className + "\" onclick=SetMenuSelectedItenm(\"sm_" + counyter.ToString() + "\");>";
                }


                htm += "<table cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">";
                htm += "<tr>";
                if (isSubMenu)
                    htm += "<td class=\"MenuNTd imgm " + SubClassName + "\">";
                else
                    htm += "<td class=\"MenuNTd imgm " + MainClassName + "\">";
                htm += "<img alt=\"תפריט\" src=\"../../Handlers/ShowImage.ashx?id=" + dtMenuItems.Rows[i]["ImgID"].ToString() + "\" width=\"16px\"/>";
                htm += "</td>";
                htm += " <td class=\"MenuNTd\">";
                htm += dtMenuItems.Rows[i]["Description"].ToString();
                htm += "</td>";
                htm += "</tr>";
                htm += "</table>";
                htm += "</td>";
                htm += "</tr>";

                counyter++;
                //if(dtMenuItems.Rows[i]["ZoomObjectID"].ToString()=="3")
                htm += GetMenuOneItems(dtMenuItems.Rows[i]["ZoomObjectID"].ToString(), true);

            }

            if (!isSubMenu)
                htm += "</table>";

            //ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "SetMenuSelectedItenm" + DateTime.Now.Ticks.ToString(), "setTimeout('SetMenuSelectedItenmLocal(\"" + MenuSelectedItem + "\");',400);", true);
        }
        return htm;
    }
    private void initFilters()
    {
        bool isFirst = true;
        string vals = "";
        List<HtmlGenericControl> controlsList = new List<HtmlGenericControl>();
        MPLayoutService wr = new MPLayoutService();
        DataTable dt = wr.MPLayout_GetFiltersData(hdnSelectedTabID.Value, SessionVersionID, ConStrings.DicAllConStrings[SessionProjectName]);
        string filters = "";

        divFilters.Controls.Clear();

        UpdatePaneldivFilters.Update();


        if (dt != null)
        {
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                HtmlGenericControl dynDivWidjet = new HtmlGenericControl("div");
                dynDivWidjet.Attributes["class"] = "dMerchandise_rightDDLs";
                dynDivWidjet.Style["width"] = "200px";

                dynDivWidjet.Style["margin-right"] = "10px";
                dynDivWidjet.Style["margin-top"] = "5px";
                dynDivWidjet.Style["margin-bottom"] = "5px";
                dynDivWidjet.Style["float"] = "right";

                HtmlGenericControl dynTblMain = new HtmlGenericControl("table");
                dynTblMain.Attributes["cellpadding"] = "2";
                dynTblMain.Attributes["cellspacing"] = "2";
                dynTblMain.Attributes["width"] = "100%";

                HtmlGenericControl dynTrMain = new HtmlGenericControl("tr");

                HtmlGenericControl dynTd1Main = new HtmlGenericControl("td");
                dynTd1Main.Attributes["class"] = "ddlFilter line";

                HtmlGenericControl dynTbInner1 = new HtmlGenericControl("table");
                dynTbInner1.Attributes["cellpadding"] = "0";
                dynTbInner1.Attributes["cellspacing"] = "0";
                dynTbInner1.Attributes["width"] = "100%";

                HtmlGenericControl dynTrInner1 = new HtmlGenericControl("tr");
                HtmlGenericControl dynTdInner1 = new HtmlGenericControl("td");
                dynTdInner1.ID = "tdName";
                dynTdInner1.Attributes["onclick"] = "//SetOnStart('250px');";
                dynTdInner1.Style["color"] = "white";
                dynTdInner1.Style["white-space"] = "nowrap";
                dynTdInner1.InnerText = dt.Rows[i]["ReportCaption"].ToString();

                dynTrInner1.Controls.Add(dynTdInner1);

                HtmlGenericControl dynTdInner2 = new HtmlGenericControl("td");
                dynTdInner2.Style["width"] = "90%";
                dynTdInner2.Style["text-align"] = "left";

                HtmlGenericControl dynTbInner2 = new HtmlGenericControl("table");
                dynTbInner2.Attributes["cellpadding"] = "0";
                dynTbInner2.Attributes["cellspacing"] = "0";
                dynTbInner2.Attributes["width"] = "100%";

                HtmlGenericControl dynTrInner2 = new HtmlGenericControl("tr");
                HtmlGenericControl dynTdInner22 = new HtmlGenericControl("td");
                dynTdInner22.Style["width"] = "65%";
                dynTdInner22.InnerHtml = "&nbsp;";

                dynTrInner2.Controls.Add(dynTdInner22);

                HtmlGenericControl dynTdInner23 = new HtmlGenericControl("td");
                dynTdInner23.Style["text-align"] = "left";
                dynTdInner23.InnerHtml = "<a href='#' onclick='ShowLoading();ClearDDL(\"" + "ctl00_ContentPlaceHolder1_ddlControle_" + dt.Rows[i]["ReportID"].ToString() + "\",\"" + dt.Rows[i]["FragmentDescription"].ToString() + "\");' class='aLink rlinkr" + dt.Rows[i]["ReportID"].ToString() + "'>clear</a>";

                dynTrInner2.Controls.Add(dynTdInner23);
                dynTbInner2.Controls.Add(dynTrInner2);

                dynTdInner2.Controls.Add(dynTbInner2);

                dynTrInner1.Controls.Add(dynTdInner2);
                dynTbInner1.Controls.Add(dynTrInner1);


                dynTd1Main.Controls.Add(dynTbInner1);
                dynTrMain.Controls.Add(dynTd1Main);


                HtmlGenericControl dynTrMain2 = new HtmlGenericControl("tr");
                string Params = hdnSrcParams.Value;
                if (Params.IndexOf("SessionUserID") == -1)
                    Params = hdnSrcParams.Value + ";SessionUserID=" + SessionUserID + ";";

                string NewParms = Params.Replace("&", ";");
                if (hdnIsFirstLoad.Value == "false")
                {
                    string[] arrParmsSP = dt.Rows[i]["Report_SP_Params"].ToString().Split(';');
                    string[] arr = Params.Replace("&", ";").Split(';');

                    if (dt.Rows[i]["ReportDataSourceID"].ToString() == "1")//query
                    {
                        NewParms = "";
                        try
                        {
                            for (int g = 0; g < arr.Length; g++)
                            {
                                if (arr[g].Trim().IndexOf("=") > -1 && arr[g].Trim() != "=")
                                {
                                    string Key = arr[g].Split('=')[0].Replace("\"", "");
                                    string Value = arr[g].Split('=')[1];
                                    hdnSrcParams.Value = hdnSrcParams.Value.Replace("&&", "&");
                                    if (hdnSrcParams.Value.Length > 0 && (hdnSrcParams.Value.Trim().IndexOf(Key.Trim()) > -1) && hdnSrcParams.Value.Trim().IndexOf("&" + Key.Trim()) > -1 && Key.IndexOf("SessionUserID") == -1)
                                        hdnSrcParams.Value = "&" + hdnSrcParams.Value.Substring(0, hdnSrcParams.Value.Trim().IndexOf("&" + Key.Trim())) + hdnSrcParams.Value.Substring(hdnSrcParams.Value.IndexOf(Key)).Substring(hdnSrcParams.Value.Substring(hdnSrcParams.Value.IndexOf(Key)).IndexOf("&")) + "&" + Key + "=" + Value;
                                    hdnSrcParams.Value = hdnSrcParams.Value.Replace("&&", "&");
                                }
                            }
                        }
                        catch (Exception)
                        {

                        }

                        NewParms = NewParms.Replace(":", "=");
                    }
                    else
                    {

                        NewParms = "";
                        try
                        {
                            for (int y = 0; y < arrParmsSP.Length; y++)
                            {
                                for (int g = 0; g < arr.Length; g++)
                                {
                                    if (arr[g].Trim().IndexOf("=") > -1 && arr[g].Trim().IndexOf("ID=") != 0 && arr[g].Trim().IndexOf("ID=") != 1 && arr[g].Trim() != "=")
                                    {
                                        string Key = arr[g].Split('=')[0].Replace("\"", "");
                                        string Value = arr[g].Split('=')[1];
                                        if ((arrParmsSP[y].Trim() == "@" + Key.Trim() || arrParmsSP[y].Trim() == Key) && arrParmsSP[y].Trim() != "")
                                        {
                                            if (hdnIsFirstLoad.Value == "true" && arrParmsSP[y].Trim().IndexOf("SessionUserID") == -1)
                                                hdnSrcParams.Value += "&" + arrParmsSP[y].Trim() + "=" + Value.Split(',')[0].Trim();
                                            NewParms += arrParmsSP[y].Trim() + ":" + Value.Split(',')[0].Trim() + ";";

                                            //hdnFilterName.Value
                                        }
                                    }
                                }
                            }
                        }
                        catch (Exception)
                        {

                        }

                        NewParms = NewParms.Replace(":", "=");
                    }
                    string val3 = "";

                    string[] arrTemp2 = hdnSrcParams.Value.Replace(";", "&").Split('&');
                    hdnSrcParams.Value = "";
                    for (int w = 0; w < arrTemp2.Length; w++)
                    {
                        if (hdnFilterName.Value.Length > 0 && arrTemp2[w].IndexOf(hdnFilterName.Value) > -1)
                        {
                            if (dt.Rows[i]["ReportID"].ToString() == hdnReportFilterID.Value)
                                arrTemp2[w] = hdnFilterName.Value.Trim() + "=" + Request.Form["ctl00$ContentPlaceHolder1$ddlControle_" + dt.Rows[i]["ReportID"].ToString()].Trim();
                        }
                        if (arrTemp2[w].Trim().Length > 0 && hdnSrcParams.Value.IndexOf(arrTemp2[w].Split('=')[0].Trim()) == -1)
                        {
                            hdnSrcParams.Value += "&" + arrTemp2[w].Split('=')[0].Trim() + "=" + arrTemp2[w].Split('=')[1].Trim();
                        }
                    }

                    if (NewParms == "")
                        NewParms = Params.Replace("&", ";");
                    string vals2 = "";
                    val3 = "";
                    string filters2 = "";
                    string Filter = "";
                    if (hdnReportFilterID.Value == dt.Rows[i]["ReportID"].ToString())
                    {


                        try
                        {
                            Params = Params.Replace(";", "&");
                            //NewParms = Params.Replace(dt.Rows[i]["FragmentDescription"].ToString(), Request.Form["ctl00$ContentPlaceHolder1$ddlControle_" + dt.Rows[i]["ReportID"].ToString()]);
                            NewParms = Params.Substring(0, Params.IndexOf(dt.Rows[i]["FragmentDescription"].ToString().Replace("@", ""))) + Params.Substring(Params.IndexOf(dt.Rows[i]["FragmentDescription"].ToString().Replace("@", ""))).Substring(Params.Substring(Params.IndexOf(dt.Rows[i]["FragmentDescription"].ToString().Replace("@", ""))).IndexOf("&")) + "&" + dt.Rows[i]["FragmentDescription"].ToString().Replace("@", "") + "=" + hdnReportFilteValue.Value;
                            NewParms = NewParms.Replace("&&", "&");
                            hdnSrcParams.Value = NewParms;

                            //setTimeout('NavAllFrame(\"" + vals + "\",\"" + filters + "\");',50);
                            //hdnNavAllScript.Value
                            string[] arrVals = hdnNavAllScript.Value.Substring(hdnNavAllScript.Value.IndexOf("\"") + 1, hdnNavAllScript.Value.IndexOf(",") - 1 - (hdnNavAllScript.Value.IndexOf("\"") + 1)).Split(';');
                            string[] arrFilters = hdnNavAllScript.Value.Substring(hdnNavAllScript.Value.IndexOf("\",\"") + 3, hdnNavAllScript.Value.IndexOf("\");'") - 1 - hdnNavAllScript.Value.IndexOf("\",\"") - 3).Split(';');

                            hdnNavAllScript.Value = "";

                            for (int t = 0; t < arrFilters.Length; t++)
                            {
                                if (arrFilters[t].Trim().Replace("@", "") == dt.Rows[i]["FragmentDescription"].ToString().Replace("@", ""))
                                {
                                    arrVals[t] = Request.Form["ctl00$ContentPlaceHolder1$ddlControle_" + dt.Rows[i]["ReportID"].ToString()];
                                    Filter = arrFilters[t].Trim().Replace("@", "");
                                    hdnFilterName.Value = arrFilters[t].Trim().Replace("@", "");

                                    val3 = arrVals[t];

                                    //if (Filter.IndexOf("SessionUserID") == -1 && hdnSrcParams.Value.IndexOf(Filter) == -1)
                                    //  hdnSrcParams.Value += "&" + Filter.Trim() + "=" + arrVals[t].Trim();
                                }
                                if (filters2.IndexOf(arrFilters[t]) == -1)
                                {
                                    vals2 += arrVals[t] + ",";
                                    filters2 += arrFilters[t] + ",";
                                }
                            }
                        }
                        catch (Exception ex)
                        {

                        }
                        vals2 = "";
                        filters2 = "";
                        string[] arrTemp = hdnSrcParams.Value.Replace(";", "&").Split('&');
                        hdnSrcParams.Value = "";
                        for (int w = 0; w < arrTemp.Length; w++)
                        {
                            if (Filter.Length > 0 && arrTemp[w].IndexOf(Filter) > -1)
                            {
                                arrTemp[w] = Filter.Trim() + "=" + val3.Trim();
                            }
                            if (arrTemp[w].Trim().Length > 0 && hdnSrcParams.Value.IndexOf(arrTemp[w].Split('=')[0].Trim()) == -1)
                            {
                                hdnSrcParams.Value += "&" + arrTemp[w].Split('=')[0].Trim() + "=" + arrTemp[w].Split('=')[1].Trim();
                                vals2 += arrTemp[w].Split('=')[1].Trim() + ",";
                                filters2 += arrTemp[w].Split('=')[0].Trim() + ",";
                            }
                        }
                    }

                    hdnNavAllScript.Value = "setTimeout('NavAllFrameRow(\"" + vals2 + "\",\"" + filters2 + "\");',350);";

                    NewParms = hdnSrcParams.Value.Replace("&", ";");
                    if (hdnSrcParams.Value.IndexOf("SessionUserID") == -1)
                        NewParms += ";SessionUserID=" + SessionUserID + ";";

                }

                if (hdnSrcParams.Value == "")
                    hdnSrcParams.Value = NewParms.Replace(";", "&");

                string[] arrTemp1 = hdnSrcParams.Value.Split('&');
                hdnSrcParams.Value = "";
                for (int w = 0; w < arrTemp1.Length; w++)
                {
                    if (arrTemp1[w].Trim().Length > 0 && hdnSrcParams.Value.IndexOf(arrTemp1[w].Split('=')[0].Trim()) == -1)
                        hdnSrcParams.Value += "&" + arrTemp1[w].Split('=')[0].Trim() + "=" + arrTemp1[w].Split('=')[1].Trim();
                }

                //string[] arrTemp3 = hdnSrcParams.Value.Replace(";", "&").Split('&');
                //hdnSrcParams.Value = "";
                //for (int w = 0; w < arrTemp3.Length; w++)
                //{
                //    if (hdnFilterName.Value.Length > 0 && arrTemp3[w].IndexOf(hdnFilterName.Value) > -1)
                //    {
                //        //if (arrTemp3[w].Split('=')[0].Trim() == dt.Rows[i]["FragmentDescription"].ToString().Replace("@", ""))
                //            if (Request.Form["ctl00$ContentPlaceHolder1$ddlControle_" + dt.Rows[i]["ReportID"].ToString()] != null)
                //                arrTemp3[w] = arrTemp3[w].Split('=')[0].Trim() + "=" + Request.Form["ctl00$ContentPlaceHolder1$ddlControle_" + dt.Rows[i]["ReportID"].ToString()];
                //    }
                //    if (arrTemp3[w].Trim().Length > 0 && hdnSrcParams.Value.IndexOf(arrTemp3[w].Split('=')[0].Trim()) == -1)
                //    {
                //        hdnSrcParams.Value += "&" + arrTemp3[w].Split('=')[0].Trim() + "=" + arrTemp3[w].Split('=')[1].Trim();
                //    }
                //}
                if (hdnSrcParams.Value.IndexOf("SessionUserID") == -1)
                    hdnSrcParams.Value = hdnSrcParams.Value + ";SessionUserID=" + SessionUserID + ";";

                string[] arrTt = hdnSrcParams.Value.Replace("&", ";").Split(';');
                hdnSrcParams.Value = "";
                for (int u = 0; u < arrTt.Length; u++)
                {
                    if (arrTt[u].IndexOf("/") > -1)
                    {
                        arrTt[u] = arrTt[u].Split('=')[0] + "=" + arrTt[u].Split('=')[1].Substring(6, 4) + arrTt[u].Split('=')[1].Substring(3, 2) + arrTt[u].Split('=')[1].Substring(0, 2);
                    }

                    if (arrTt[u].Trim().Length > 0 && hdnSrcParams.Value.IndexOf(arrTt[u].Split('=')[0].Trim()) == -1)
                    {
                        hdnSrcParams.Value += "&" + arrTt[u].Split('=')[0].Trim() + "=" + arrTt[u].Split('=')[1].Trim();
                    }
                }
                DataTable dtControl = wr.MPLayout_GetQueryDataForControl(dt.Rows[i]["ReportID"].ToString(), hdnSrcParams.Value.Replace("&", ";"), SessionUserID, SessionVersionID, ConStrings.DicAllConStrings[SessionProjectName]);
                if (dtControl != null)
                {
                    if (dtControl.Rows.Count > 0)
                    {
                        filters += "" + dt.Rows[i]["FragmentDescription"].ToString() + ";";
                        if (hdnIsFirstLoad.Value == "true")
                            hdnSrcParams.Value += "&" + dt.Rows[i]["FragmentDescription"].ToString() + "=";
                    }

                    if (dt.Rows[i]["FragmentDescription"].ToString().IndexOf("@FromDate") == -1 && dt.Rows[i]["FragmentDescription"].ToString().IndexOf("@ToDate") == -1)
                    {
                        HtmlGenericControl dynTdMain2 = new HtmlGenericControl("td");
                        DropDownList ddl = new DropDownList();

                        ddl.ID = "ddlControle_" + dt.Rows[i]["ReportID"].ToString();
                        ddl.CssClass = "ddlFilterItem " + dt.Rows[i]["FragmentDescription"].ToString().Replace("@", "");
                        //ddl.Attributes["onchange"] = "ShowLoading();NavFrame(this.value,'" + dt.Rows[i]["FragmentDescription"].ToString() + "')";
                        ddl.Attributes["onchange"] = "SetFilterName(this.className.toString().split('ddlFilterItem ').join(''));ShowLoading();setTimeout('NavAllFilters();', 250);$('#" + hdnReportFilterID.ClientID + "').val('" + dt.Rows[i]["ReportID"].ToString() + "');$('#" + hdnReportFilteValue.ClientID + "').val(this.value);" + hdnNavAllScript.Value + ";setTimeout('SetFilterData(\"" + dt.Rows[i]["ReportID"].ToString() + "\");',150);";



                        ddl.DataSource = dtControl;
                        ddl.DataTextField = "Key";
                        ddl.DataValueField = "Value";
                        ddl.DataBind();



                        try
                        {
                            if (Request.Form["ctl00$ContentPlaceHolder1$ddlControle_" + dt.Rows[i]["ReportID"].ToString()] != null)
                                ddl.SelectedValue = Request.Form["ctl00$ContentPlaceHolder1$ddlControle_" + dt.Rows[i]["ReportID"].ToString()];
                        }
                        catch (Exception ex)
                        {

                        }
                        if (dtControl.Rows.Count > 0)
                        {
                            int tt = 0;
                            for (int u = 0; u < ddl.Items.Count; u++)
                            {
                                if (dt.Rows[i]["DefaltVal"].ToString() != "" && ddl.Items[u].Value == Convert.ToInt32(dt.Rows[i]["DefaltVal"].ToString()).ToString())
                                    ddl.Items[u].Selected = true;
                                tt++;
                            }
                        }

                        string[] arrTemp2 = hdnSrcParams.Value.Replace(";", "&").Split('&');
                        hdnSrcParams.Value = "";
                        for (int w = 0; w < arrTemp2.Length; w++)
                        {
                            //if (hdnFilterName.Value.Length > 0 && arrTemp2[w].IndexOf(hdnFilterName.Value) > -1)
                            {
                                if (arrTemp2[w].Split('=')[0].Trim() == dt.Rows[i]["FragmentDescription"].ToString().Replace("@", ""))
                                    arrTemp2[w] = arrTemp2[w].Split('=')[0].Trim() + "=" + ddl.SelectedValue;
                            }
                            if (arrTemp2[w].Trim().Length > 0 && hdnSrcParams.Value.IndexOf(arrTemp2[w].Split('=')[0].Trim()) == -1)
                            {
                                hdnSrcParams.Value += "&" + arrTemp2[w].Split('=')[0].Trim() + "=" + arrTemp2[w].Split('=')[1].Trim();
                            }
                        }


                        if (dt.Rows[i]["DefaltVal"].ToString() != "" && ddl.Items.Count >= i)
                        {
                            try
                            {
                                //ddl.SelectedValue = dt.Rows[i]["DefaltVal"].ToString();
                                vals += dt.Rows[i]["DefaltVal"].ToString() + ";";
                                if (hdnIsFirstLoad.Value == "true")
                                    hdnSrcParams.Value += dt.Rows[i]["DefaltVal"].ToString();
                            }
                            catch (Exception ex)
                            {
                            }
                        }
                        else
                        {
                            //vals += "0;";
                            try
                            {
                                //ddl.SelectedValue = dt.Rows[i]["DefaltVal"].ToString();
                                if (hdnReportFilterID.Value == dt.Rows[i]["ReportID"].ToString())
                                {
                                    vals += Request.Form["ctl00$ContentPlaceHolder1$ddlControle_" + dt.Rows[i]["ReportID"].ToString()] + ";";
                                    if (hdnIsFirstLoad.Value == "true")
                                        hdnSrcParams.Value += Request.Form["ctl00$ContentPlaceHolder1$ddlControle_" + dt.Rows[i]["ReportID"].ToString()];
                                }
                                else
                                {
                                    vals += dtControl.Rows[0][0].ToString().Trim() + ";";
                                    if (hdnIsFirstLoad.Value == "true")
                                        hdnSrcParams.Value += dtControl.Rows[0][0].ToString().Trim();
                                }
                            }
                            catch (Exception ex)
                            {
                                vals += "0;";
                                if (hdnIsFirstLoad.Value == "true")
                                    hdnSrcParams.Value += "0";
                            }

                        }




                        //ddl.Attributes["size"] = "9";
                        HtmlGenericControl scrScr = new HtmlGenericControl("div");
                        string Scr = "<script>setTimeout('SetFilterData(\"" + dt.Rows[i]["ReportID"].ToString() + "\");',350);</script>";
                        //ddl.Attributes["onload"] = "alert();setTimeout('SetFilterData(\"" + dt.Rows[i]["ReportID"].ToString() + "\");',50);";
                        scrScr.InnerHtml = Scr;
                        dynTdMain2.Controls.Add(scrScr);
                        dynTdMain2.Controls.Add(ddl);



                        dynTrMain2.Controls.Add(dynTdMain2);

                    }
                    else
                    {
                        CultureInfo culture = CultureInfo.CreateSpecificCulture("he-IL");
                        Thread.CurrentThread.CurrentCulture = culture;

                        HtmlGenericControl dynTdMain2 = new HtmlGenericControl("td");
                        TextBox txt = new TextBox();
                        txt.Style["width"] = "98%";
                        txt.CssClass = "dtp ddlFilterItem " + dt.Rows[i]["FragmentDescription"].ToString().Replace("@", "");
                        txt.Text = Convert.ToDateTime(dtControl.Rows[0][0].ToString(), culture).ToString("dd/MM/yyyy");
                        txt.ID = "ddlControle_" + dt.Rows[i]["ReportID"].ToString();
                        txt.ClientIDMode = ClientIDMode.Static;

                        try
                        {
                            if (Request.Form["ctl00$ContentPlaceHolder1$ddlControle_" + dt.Rows[i]["ReportID"].ToString()] != null)
                                txt.Text = Request.Form["ctl00$ContentPlaceHolder1$ddlControle_" + dt.Rows[i]["ReportID"].ToString()];
                        }
                        catch (Exception ex)
                        {

                        }

                        string text = txt.Text;
                        if (text.Length == 0)
                            text = dtControl.Rows[0][0].ToString();
                        if (dt.Rows[i]["DefaltVal"].ToString() != "" && hdnIsFirstLoad.Value == "true")
                        {
                            txt.Text = dt.Rows[i]["DefaltVal"].ToString();
                            text = txt.Text;
                            vals += Convert.ToDateTime(dt.Rows[i]["DefaltVal"].ToString(), culture).ToString("yyyyMMdd") + ";";
                            if (hdnIsFirstLoad.Value == "true")
                                hdnSrcParams.Value += Convert.ToDateTime(dt.Rows[i]["DefaltVal"].ToString(), culture).ToString("yyyyMMdd");
                        }
                        else
                        {


                            if (hdnIsFirstLoad.Value == "true")
                                hdnSrcParams.Value += Convert.ToDateTime(text, culture).ToString("yyyyMMdd");
                        }
                        vals += Convert.ToDateTime(text, culture).ToString("yyyyMMdd") + ";";
                        txt.Attributes["onchange"] = "SetFilterName('" + dt.Rows[i]["FragmentDescription"].ToString().Replace("@", "") + "');ShowLoading();setTimeout('NavAllFilters();', 1250);$('#" + hdnReportFilterID.ClientID + "').val('" + dt.Rows[i]["ReportID"].ToString() + "');$('#" + hdnReportFilteValue.ClientID + "').val(this.value);" + hdnNavAllScript.Value + ";setTimeout('SetFilterData(\"" + dt.Rows[i]["ReportID"].ToString() + "\");',150);";
                        //"ShowLoading();try{setTimeout('NavAllFrameRow(\"" + vals + "\",\"" + filters + "\");',250);NavFrame(this.value.substr(6,4)+this.value.substr(3,2)+this.value.substr(0,2),'" + dt.Rows[i]["FragmentDescription"].ToString() + "')}catch(e){NavFrame('0','" + dt.Rows[i]["FragmentDescription"].ToString() + "')}";

                        ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "set22Pickers111_" + DateTime.Now.Ticks.ToString(), "$('.rlinkr" + dt.Rows[i]["ReportID"].ToString() + "').text('');", true);

                        dynDivWidjet.Style["height"] = "60px";

                        dynTdMain2.Controls.Add(txt);
                        dynTrMain2.Controls.Add(dynTdMain2);

                        ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "setPickers_" + DateTime.Now.Ticks.ToString(), "setTimeout('setPickers();',300);", true);
                    }


                }






                dynTblMain.Controls.Add(dynTrMain);
                dynTblMain.Controls.Add(dynTrMain2);

                dynDivWidjet.Controls.Add(dynTblMain);
                controlsList.Add(dynDivWidjet);

                //UpdatePaneldivFilters.Update();

                //if(isFirst)
                //ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "NavFrame_" + DateTime.Now.Ticks.ToString(), "setTimeout('ShowFiltersB();',50);", true);
                isFirst = false;
            }

            if (SessionLanguage.ToLower() != "he")
            {
                controlsList.Reverse();
            }

            foreach (var item in controlsList)
            {
                divFilters.Controls.Add(item);
            }
            UpdatePaneldivFilters.Update();

            if (hdnIsFirstLoad.Value == "true")
            {
                hdnNavAllScript.Value = "setTimeout('NavAllFrameRow(\"" + vals + "\",\"" + filters + "\");',50);";
                ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "NavFrame_" + DateTime.Now.Ticks.ToString(), "setTimeout('NavAllFrame(\"" + vals + "\",\"" + filters + "\");',250);", true);
            }
        }

    }
}