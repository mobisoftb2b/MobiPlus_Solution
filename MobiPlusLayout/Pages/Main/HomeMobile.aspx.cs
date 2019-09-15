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
        if (!IsPostBack)
        {
            if (Request.QueryString["SelectedMenuItem"] != null)
                MenuSelectedItem = Request.QueryString["SelectedMenuItem"].ToString();
            init();
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
    private string GetMenuOneItems(string MenuID, bool isSubMenu)
    {
        counter++;
        if (counter > 1105)
        {
            return "";
        }
        MPLayoutService wr = new MPLayoutService();
        DataTable dtMenuItems = wr.Layout_GetMenuItemsDT(MenuID, ConStrings.DicAllConStrings[SessionProjectName]);
        string htm = "<table cellpadding=\"0\" cellspacing=\"0\" width=\"99%\">";

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
            htm += GetMenuOneItems(dtMenuItems.Rows[i]["ZoomObjectID"].ToString(), true);

        }

        if (!isSubMenu)
            htm += "</table>";

        //ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "SetMenuSelectedItenm" + DateTime.Now.Ticks.ToString(), "setTimeout('SetMenuSelectedItenmLocal(\"" + MenuSelectedItem + "\");',400);", true);

        return htm;
    }
    private void initFilters()
    {
        bool isFirst = true;
        string vals = "";
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
                dynTdInner23.InnerHtml = "<a href='#' onclick='ShowLoading();ClearDDL(\"" + "ctl00_ContentPlaceHolder1_ddlControle_" + dt.Rows[i]["ReportID"].ToString() + "\",\"" + dt.Rows[i]["FragmentDescription"].ToString() + "\");' class='aLink'>נקה</a>";

                dynTrInner2.Controls.Add(dynTdInner23);
                dynTbInner2.Controls.Add(dynTrInner2);

                dynTdInner2.Controls.Add(dynTbInner2);

                dynTrInner1.Controls.Add(dynTdInner2);
                dynTbInner1.Controls.Add(dynTrInner1);


                dynTd1Main.Controls.Add(dynTbInner1);
                dynTrMain.Controls.Add(dynTd1Main);


                HtmlGenericControl dynTrMain2 = new HtmlGenericControl("tr");

                DataTable dtControl = wr.MPLayout_GetQueryDataForControl(dt.Rows[i]["ReportID"].ToString(), SessionVersionID, ConStrings.DicAllConStrings[SessionProjectName]);
                if (dtControl != null)
                {
                    if (dt.Rows[i]["FragmentDescription"].ToString().IndexOf("@FromDate") == -1 && dt.Rows[i]["FragmentDescription"].ToString().IndexOf("@ToDate") == -1)
                    {
                        HtmlGenericControl dynTdMain2 = new HtmlGenericControl("td");
                        DropDownList ddl = new DropDownList();
                        ddl.ID = "ddlControle_" + dt.Rows[i]["ReportID"].ToString();
                        ddl.CssClass = "ddlFilterItem";
                        ddl.Attributes["onchange"] = "ShowLoading();NavFrame(this.value,'" + dt.Rows[i]["FragmentDescription"].ToString() + "')";

                        ddl.DataSource = dtControl;
                        ddl.DataTextField = "Key";
                        ddl.DataValueField = "Value";
                        ddl.DataBind();
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

                        if (dt.Rows[i]["DefaltVal"].ToString() != "" && ddl.Items.Count >= i)
                        {
                            try
                            {
                                //ddl.SelectedValue = dt.Rows[i]["DefaltVal"].ToString();
                                vals += dt.Rows[i]["DefaltVal"].ToString() + ";";
                            }
                            catch (Exception ex)
                            {
                            }
                        }
                        else
                        {
                            vals += "0;";
                        }




                        //ddl.Attributes["size"] = "9";

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
                        txt.CssClass = "dtp";
                        txt.Text = Convert.ToDateTime(dtControl.Rows[0][0].ToString(), culture).ToString("dd/MM/yyyy");
                        if (dt.Rows[i]["DefaltVal"].ToString() != "")
                        {
                            txt.Text = dt.Rows[i]["DefaltVal"].ToString();
                            vals += Convert.ToDateTime(dt.Rows[i]["DefaltVal"].ToString(), culture).ToString("yyyyMMdd") + ";";
                        }
                        else
                        {
                            vals += Convert.ToDateTime(dtControl.Rows[0][0].ToString(), culture).ToString("yyyyMMdd") + ";";
                        }
                        txt.Attributes["onchange"] = "ShowLoading();try{NavFrame(this.value.substr(6,4)+this.value.substr(3,2)+this.value.substr(0,2),'" + dt.Rows[i]["FragmentDescription"].ToString() + "')}catch(e){NavFrame('0','" + dt.Rows[i]["FragmentDescription"].ToString() + "')}";



                        dynDivWidjet.Style["height"] = "60px";

                        dynTdMain2.Controls.Add(txt);
                        dynTrMain2.Controls.Add(dynTdMain2);

                        ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "setPickers_" + DateTime.Now.Ticks.ToString(), "setTimeout('setPickers();',100);", true);
                    }

                    if (dtControl.Rows.Count > 0)
                    {
                        filters += "" + dt.Rows[i]["FragmentDescription"].ToString() + ";";

                    }
                }






                dynTblMain.Controls.Add(dynTrMain);
                dynTblMain.Controls.Add(dynTrMain2);

                dynDivWidjet.Controls.Add(dynTblMain);
                divFilters.Controls.Add(dynDivWidjet);

                UpdatePaneldivFilters.Update();

                //if(isFirst)
                //ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "NavFrame_" + DateTime.Now.Ticks.ToString(), "setTimeout('ShowFiltersB();',50);", true);
                isFirst = false;
            }
            if (hdnIsFirstLoad.Value == "true")
                ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "NavFrame_" + DateTime.Now.Ticks.ToString(), "setTimeout('NavAllFrame(\"" + vals + "\",\"" + filters + "\");',50);", true);
        }

    }
}