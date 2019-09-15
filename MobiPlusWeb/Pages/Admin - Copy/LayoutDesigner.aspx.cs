using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MainService;
using System.Data;
using System.Web.UI.HtmlControls;

public partial class Pages_Admin_LayoutDesigner : PageBaseCls
{
    private int itemsCounter = 0;
    public string LayoutTypeID = "1";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Request.QueryString["LayoutTypeID"] != null)
                LayoutTypeID = Request.QueryString["LayoutTypeID"].ToString();
            itemsCounter = 0;
            init();
            initConntrols();
        }
    }
    protected void btnGetTabEditData_Click(object sender, EventArgs e)
    {
        GetTabsByForm();
    }
    protected void btnSetFormTab_Click(object sender, EventArgs e)
    {
        if (SetFormTab())
        {
            lblTabMsg.Text = "הטאב נשמר בהצלחה";
            ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "CloseWinTabsEdit();", "setTimeout('CloseWinTabsEdit();',100);", true);
        }
        else
            lblTabMsg.Text = "אראה שגיאה בשמירת הטאב";

        upTabMSG.Update();

        GetTabsByForm();

        
    }
    protected void ddlTabs_SelectedIndexChanged(object sender, EventArgs e)
    {
        GetTabData();
    }
    protected void initConntrols_SelectedIndexChanged(object sender, EventArgs e)
    {
        GetTabsByForm();
        initConntrols();
    }
    protected void dllProjects_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (Request.QueryString["LayoutTypeID"] != null)
            LayoutTypeID = Request.QueryString["LayoutTypeID"].ToString();
        MobiPlusWS WR = new MobiPlusWS();
        DataTable dt = WR.Layout_GetFormsByProjectID(LayoutTypeID, dllProjects.SelectedValue, ConStrings.DicAllConStrings[SessionProjectName]);

        if (dt != null)
        {
            ddlForms.DataSource = dt;
            ddlForms.DataTextField = "FormName";
            ddlForms.DataValueField = "FormID";
            ddlForms.DataBind();
            ddlForms.SelectedValue = "-1";
            UpdatePanelddlForms.Update();
        }
    }
    protected void dllProjects_SelectedIndexChanged2(object sender, EventArgs e)
    {
        if (Request.QueryString["LayoutTypeID"] != null)
            LayoutTypeID = Request.QueryString["LayoutTypeID"].ToString();
        MobiPlusWS WR = new MobiPlusWS();
        DataTable dt = WR.Layout_GetFormsByProjectID(LayoutTypeID, dllProjects.SelectedValue, ConStrings.DicAllConStrings[SessionProjectName]);

        if (dt != null)
        {
            ddlForms.DataSource = dt;
            ddlForms.DataTextField = "FormName";
            ddlForms.DataValueField = "FormID";
            ddlForms.DataBind();
            UpdatePanelddlForms.Update();

            ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "SetFormSelected", "setTimeout('SetFormSelected();',100);", true);
        }
    }
    protected void lbDelTab_Click(object sender, EventArgs e)
    {
        if (DeleteFormTab())
        {
            lblTabMsg.Text = "הטאב נמחק בהצלחה";
            //dllProjects.SelectedValue = "-1";
            UpdatePanel3.Update();
            ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "CloseWinTabsEdit();", "setTimeout('CloseWinTabsEdit();',100);", true);
        }
        else
            lblTabMsg.Text = "אראה שגיאה במחיקת הטאב";

        upTabMSG.Update();

    }
    private void init()
    {
        if (Request.QueryString["LayoutTypeID"] != null)
            LayoutTypeID = Request.QueryString["LayoutTypeID"].ToString();

        MobiPlusWS WR = new MobiPlusWS();

        dllProjects_SelectedIndexChanged(null, new EventArgs());

        DataTable dtTypes = WR.Layout_GetTypes(ConStrings.DicAllConStrings[SessionProjectName]);

        if (dtTypes != null)
        {
            ddlLayoutType.DataSource = dtTypes;
            ddlLayoutType.DataTextField = "LayoutType";
            ddlLayoutType.DataValueField = "LayoutTypeID";
            ddlLayoutType.DataBind();
        }

        DataTable dtTabAlignments = WR.Layout_GetTabAlignments(ConStrings.DicAllConStrings[SessionProjectName]);

        if (dtTabAlignments != null)
        {
            ddlTabAlignments.DataSource = dtTabAlignments;
            ddlTabAlignments.DataTextField = "TabAlignment";
            ddlTabAlignments.DataValueField = "TabAlignmentID";
            ddlTabAlignments.DataBind();
        }

        DataTable dtProjects = WR.Layout_GetProjects(ConStrings.DicAllConStrings[SessionProjectName]);

        if (dtProjects != null)
        {
            dllProjects.DataSource = dtProjects;
            dllProjects.DataTextField = "ProjectName";
            dllProjects.DataValueField = "ProjectID";
            dllProjects.DataBind();

            dllProjects_SelectedIndexChanged(null, new EventArgs());
        }

        DataTable dtAlllR = WR.Layout_GetAllReports(ConStrings.DicAllConStrings[SessionProjectName], LayoutTypeID);
        int cpounter = 0;
        int IndexForGraf = 0;
        int y = 0;
        for (int ry = 1; ry < 15; ry++)
        {
            IndexForGraf = ry;
            y = ry;
            if (y == 3)
            {
                y = 4;
                ry = 4;
            }

            if (y == 6)
            {
                y = 7;
                ry = 7;
            }

            if (y >= 7 && y <= 10)
            {
                y = 10;
                ry = 10;
            }
            if (y > 10 && y <= 14)
            {
                y = 12;
                ry = 14;
            }

            DataView dv = dtAlllR.DefaultView;
            if (y >= 7 && y <= 10)//grafs
                dv.RowFilter = "ReportTypeID=7 OR ReportTypeID=8 OR ReportTypeID=9 OR ReportTypeID=10";
            else if (y >= 10 && y <= 13)//sections
                dv.RowFilter = "ReportTypeID=11 OR ReportTypeID=12 OR ReportTypeID=13";
            else
                dv.RowFilter = "ReportTypeID=" + y.ToString();
            DataTable dtAlll = dv.ToTable();



            if (dtAlll != null)
            {
                HtmlGenericControl dynDivHead = new HtmlGenericControl("div");
                dynDivHead.Attributes["class"] = "dHeadCat";
                switch (y)
                {
                    case 1:
                        dynDivHead.InnerText = "דוחות טבלאיים";
                        break;
                    case 2:
                        dynDivHead.InnerText = "דוחות מפתח ערך";
                        break;
                    case 3:
                        //dynDivHead.InnerText = "דוחות גרפיים";
                        break;
                    case 4:
                        dynDivHead.InnerText = "דוחות WEB";
                        break;
                    case 5:
                        dynDivHead.InnerText = "דוחות כלליים";
                        break;
                    case 7:
                    case 8:
                    case 9:
                    case 10:
                        dynDivHead.InnerText = "דוחות גרפיים";
                        break;
                    case 11:
                    case 12:
                        dynDivHead.InnerText = "רכיבים";
                        break;
                }

                HtmlGenericControl dynDivAllSection = new HtmlGenericControl("div");


                for (int i = 0; i < dtAlll.Rows.Count; i++)
                {
                    cpounter++;

                    HtmlGenericControl dynDivWidjet = new HtmlGenericControl("div");

                    dynDivWidjet.ID = "draggable" + dtAlll.Rows[i]["FragmentID"].ToString();//cpounter.ToString();
                    dynDivWidjet.Attributes["class"] = "FragmentM dd bor rig";
                    dynDivWidjet.Attributes["onclick"] = "ObjClick(\"ContentPlaceHolder1_" + dynDivWidjet.ClientID + "\",false,0);";
                    if (y >= 7 && y <= 10)
                    {
                        dynDivWidjet.Attributes["class"] = "FragmentM dd bor rig MobiGraf";
                        dynDivWidjet.Attributes["onclick"] = "ObjClick(\"ContentPlaceHolder1_" + dynDivWidjet.ClientID + "\",true," + dtAlll.Rows[i]["ReportTypeID"].ToString() + ");";
                    }

                    if (y == 5)
                    {
                        dynDivWidjet.Attributes["class"] = "FragmentM dd bor rig MobiCompiled";
                        dynDivWidjet.Attributes["onclick"] = "ObjClick(\"ContentPlaceHolder1_" + dynDivWidjet.ClientID + "\",true," + dtAlll.Rows[i]["ReportTypeID"].ToString() + ");";
                    }
                    else if (y == 11)
                    {
                        dynDivWidjet.Attributes["class"] = "FragmentM dd bor rig MobiSections";
                        dynDivWidjet.Attributes["onclick"] = "ObjClick(\"ContentPlaceHolder1_" + dynDivWidjet.ClientID + "\",true," + dtAlll.Rows[i]["ReportTypeID"].ToString() + ");";
                    }
                    else if (y == 12)
                    {
                        dynDivWidjet.Attributes["class"] = "FragmentM dd bor rig MobiEmpty";
                        dynDivWidjet.Attributes["onclick"] = "ObjClick(\"ContentPlaceHolder1_" + dynDivWidjet.ClientID + "\",true," + dtAlll.Rows[i]["ReportTypeID"].ToString() + ");";
                    }

                    HtmlGenericControl dynDivFragmentHead = new HtmlGenericControl("div");
                    dynDivFragmentHead.Attributes["class"] = "FragmentHead";

                    HtmlGenericControl dynDivStyles = new HtmlGenericControl("div");
                    dynDivStyles.Attributes["class"] = "";
                    dynDivStyles.ID = "dynDivStyles_" + itemsCounter.ToString();
                    dynDivStyles.InnerHtml = "<div class='rrgg' id='dr_" + itemsCounter.ToString() + "'></div>";
                    dynDivStyles.Style["padding-top"] = "100px";
                    dynDivStyles.Style["color"] = "#4F6380";


                    HtmlGenericControl dynDivJumpWiX = new HtmlGenericControl("div");
                    dynDivJumpWiX.ID = "JumpWiXLeft" + dtAlll.Rows[i]["FragmentID"].ToString();//cpounter.ToString();
                    dynDivJumpWiX.Attributes["class"] = "JumpWiXLeft";
                    HtmlGenericControl dynIMGX = new HtmlGenericControl("image");
                    dynIMGX.Attributes["alt"] = "סגור";
                    dynIMGX.Attributes["src"] = "../../img/X.png";
                    dynIMGX.Attributes["class"] = "imngX clseccc";
                    dynIMGX.Style["padding-top"] = "2px";
                    dynIMGX.Attributes["onclick"] = "CloseWinReport('" + dynDivWidjet.ID.Replace("draggable", "") + "');";
                    dynDivJumpWiX.Controls.Add(dynIMGX);

                    HtmlGenericControl dynDivFragmentHeadText = new HtmlGenericControl("div");
                    dynDivFragmentHeadText.Attributes["class"] = "FragmentHeadText";
                    dynDivFragmentHeadText.InnerText = dtAlll.Rows[i]["ReportCaption"].ToString();

                    dynDivFragmentHeadText.InnerHtml = dynDivFragmentHeadText.InnerHtml + "<div style='float:left;vertical-align:top;'><a style='color: White;' href='javascript:SetEditReport(\"" + dtAlll.Rows[i]["ReportID"].ToString() + "\");' class='EditFr'>ערוך</a></div>";


                    HtmlGenericControl dynDivimgg = new HtmlGenericControl("div");
                    dynDivimgg.ID = "report" + itemsCounter.ToString();
                    dynDivimgg.Attributes["class"] = "imgg";

                    itemsCounter++;

                    HtmlGenericControl dynTBLOne = new HtmlGenericControl("table");
                    dynTBLOne.Style["border"] = "1px dotted gray";
                    dynTBLOne.Style["background-color"] = "White";
                    dynTBLOne.Style["color"] = "gray";
                    HtmlGenericControl dynTROne = new HtmlGenericControl("tr");
                    HtmlGenericControl dynTD1 = new HtmlGenericControl("td");
                    HtmlGenericControl dynIMG = new HtmlGenericControl("image");


                    switch (y)
                    {
                        case 1:
                            dynIMG.Attributes["src"] = "../../Img/report.png";
                            break;
                        case 2:
                            dynIMG.Attributes["src"] = "../../Img/keyval.png";
                            break;
                        case 3:
                            dynIMG.Attributes["src"] = "../../Img/graf.jpg";
                            break;
                        case 4:
                            dynIMG.Attributes["src"] = "../../Img/web.jpg";
                            break;
                        case 5:
                            dynIMG.Attributes["src"] = "../../Img/gen.png";
                            break;
                        case 7:
                        case 8:
                        case 9:
                        case 10:
                            dynIMG.Attributes["src"] = "../../Img/bar_chart.png";
                            break;
                        case 11:
                        case 12:
                            dynIMG.Attributes["src"] = "../../Img/gen.png";
                            break;
                    }
                    dynIMG.Attributes["class"] = "imgrep";
                    dynTD1.Controls.Add(dynIMG);
                    dynTROne.Controls.Add(dynTD1);

                    HtmlGenericControl dynTD2 = new HtmlGenericControl("td");

                    HtmlGenericControl dynTBLRep = new HtmlGenericControl("table");
                    dynTBLRep.Attributes["cellpadding"] = "2";
                    dynTBLRep.Attributes["cellspacing"] = "2";


                    HtmlGenericControl dynTRRep = new HtmlGenericControl("tr");
                    HtmlGenericControl dynTDRep = new HtmlGenericControl("td");
                    dynTDRep.InnerText = dtAlll.Rows[i]["FragmentName"].ToString();
                    dynTDRep.Attributes["class"] = "repItem";

                    dynTRRep.Controls.Add(dynTDRep);
                    dynTBLRep.Controls.Add(dynTRRep);
                    dynTRRep = new HtmlGenericControl("tr");
                    dynTDRep = new HtmlGenericControl("td");


                    dynTDRep.InnerText = dtAlll.Rows[i]["ReportType"].ToString();
                    dynTDRep.Attributes["class"] = "repItem";

                    dynTRRep.Controls.Add(dynTDRep);
                    dynTBLRep.Controls.Add(dynTRRep);
                    dynTRRep = new HtmlGenericControl("tr");
                    dynTDRep = new HtmlGenericControl("td");


                    dynTDRep.InnerText = dtAlll.Rows[i]["FragmentDescription"].ToString();
                    dynTDRep.Attributes["class"] = "repItem";


                    dynTRRep.Controls.Add(dynTDRep);
                    dynTBLRep.Controls.Add(dynTRRep);
                    dynTRRep = new HtmlGenericControl("tr");
                    dynTDRep = new HtmlGenericControl("td");


                    dynTBLRep.Controls.Add(dynTRRep);
                    dynTD2.Controls.Add(dynTBLRep);
                    dynTROne.Controls.Add(dynTD2);
                    dynTBLOne.Controls.Add(dynTROne);

                    dynDivimgg.Controls.Add(dynTBLOne);
                    dynDivFragmentHead.Controls.Add(dynDivJumpWiX);
                    dynDivFragmentHead.Controls.Add(dynDivFragmentHeadText);
                    dynDivFragmentHead.Controls.Add(dynDivimgg);
                    dynDivWidjet.Controls.Add(dynDivFragmentHead);
                    dynDivWidjet.Controls.Add(dynDivStyles);
                    dynDivAllSection.Controls.Add(dynDivWidjet);
                    //dynTR.Controls.Add(dynTD);

                    if ((i + 1) % 5 == 0)
                    {
                        HtmlGenericControl dynDivBR = new HtmlGenericControl("div");
                        dynDivBR.InnerHtml = "<br/>";
                        dynDivAllSection.Controls.Add(dynDivBR);
                        //HtmlGenericControl dynTD4 = new HtmlGenericControl("td");
                        //dynTD4.Style["width"]="20px";
                        //dynTR.Controls.Add(dynTD4);

                        //dynTBLAll.Controls.Add(dynTR);
                        //dynTR = new HtmlGenericControl("tr");
                    }
                }
                dTBL.Controls.Add(dynDivHead);
                //dynTBLAll.Controls.Add(dynTR);

                HtmlGenericControl dynDivObj = new HtmlGenericControl("div");
                dynDivObj.Style["max-height"] = "500px";
                dynDivObj.Style["width"] = "1080px";
                dynDivObj.Style["overflow-y"] = "auto";
                dynDivObj.Style["overflow-x"] = "hidden";

                dynDivObj.Controls.Add(dynDivAllSection);
                dTBL.Controls.Add(dynDivObj);

            }
        }

    }
    private void GetTabsByForm()
    {
        MobiPlusWS WR = new MobiPlusWS();
        DataTable dt = WR.Layout_GetTabsByForm(ddlForms.SelectedValue, ConStrings.DicAllConStrings[SessionProjectName]);

        if (dt != null)
        {
            ddlTabs.DataSource = dt;
            ddlTabs.DataTextField = "TabName";
            ddlTabs.DataValueField = "TabID";
            ddlTabs.DataBind();

            upddlTabs.Update();
        }
    }
    private bool SetFormTab()
    {
        MobiPlusWS WR = new MobiPlusWS();
        if (Request.QueryString["LayoutTypeID"] != null)
            LayoutTypeID = Request.QueryString["LayoutTypeID"].ToString();
        return WR.Layout_SetFormTab(ddlForms.SelectedValue, ddlTabs.SelectedValue, txtTabName.Text, txtTabDesc.Text, "1", SessionUserID, ConStrings.DicAllConStrings[SessionProjectName], LayoutTypeID, hdnJsonFilters.Value,"");
    }
    private bool DeleteFormTab()
    {
        MobiPlusWS WR = new MobiPlusWS();
        if (Request.QueryString["LayoutTypeID"] != null)
            LayoutTypeID = Request.QueryString["LayoutTypeID"].ToString();
        return WR.Layout_SetFormTab(ddlForms.SelectedValue, ddlTabs.SelectedValue, txtTabName.Text, txtTabDesc.Text, "0", SessionUserID, ConStrings.DicAllConStrings[SessionProjectName], LayoutTypeID,"[]","");
    }
    private void GetTabData()
    {
        MobiPlusWS WR = new MobiPlusWS();
        DataTable dt = WR.Layout_GetTabData(ddlTabs.SelectedValue, ConStrings.DicAllConStrings[SessionProjectName]);
        if (dt != null && dt.Rows.Count > 0)
        {
            txtTabName.Text = dt.Rows[0]["TabName"].ToString();
            txtTabDesc.Text = dt.Rows[0]["TabDescription"].ToString();
            upTabName.Update();
            upTabDesc.Update();
        }

        initConntrols();
    }
    private void initConntrols()
    {
        MobiPlusWS WR = new MobiPlusWS();
        DataTable dt = WR.Layout_GetFilterControls(ddlTabs.SelectedValue,ConStrings.DicAllConStrings[SessionProjectName]);

        HtmlGenericControl dynTBL = new HtmlGenericControl("table");
        dynTBL.Style["width"] = "327px";
        dynTBL.Attributes["cellspacing"] = "0";
        dynTBL.Attributes["cellpadding"] = "0";

        HtmlGenericControl dynTrHead = new HtmlGenericControl("tr");
        dynTrHead.Attributes["class"] = "dynTrHead";
        HtmlGenericControl dynTdHead1 = new HtmlGenericControl("td");
        HtmlGenericControl dynTdHead2 = new HtmlGenericControl("td");
        HtmlGenericControl dynTdHead3 = new HtmlGenericControl("td");
        HtmlGenericControl dynTdHead4 = new HtmlGenericControl("td");

        dynTdHead1.InnerText = "בחר";
        dynTdHead2.InnerText = "מסנן";
        dynTdHead3.InnerText = "סדר";
        dynTdHead4.InnerText = "ברירת מחדל";

        dynTrHead.Controls.Add(dynTdHead1);
        dynTrHead.Controls.Add(dynTdHead2);
        dynTrHead.Controls.Add(dynTdHead3);
        dynTrHead.Controls.Add(dynTdHead4);

        dynTBL.Controls.Add(dynTrHead);

        if (dt != null && dt.Rows.Count > 0)
        {
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                HtmlGenericControl dynTrBody = new HtmlGenericControl("tr");
                HtmlGenericControl dynTd1 = new HtmlGenericControl("td");
                HtmlGenericControl dynTd2 = new HtmlGenericControl("td");
                HtmlGenericControl dynTd3 = new HtmlGenericControl("td");
                HtmlGenericControl dynTd4 = new HtmlGenericControl("td");
                
                dynTd1.Attributes["class"] = "BorderBot1";
                dynTd2.Attributes["class"] = "BorderBot1";
                dynTd3.Attributes["class"] = "BorderBot1";
                dynTd4.Attributes["class"] = "BorderBot1";

                if (dt.Rows[i]["IsChecked"].ToString()=="1")
                    dynTd1.InnerHtml = "<input type='checkbox' checked='true' id='cbFilter_" + dt.Rows[i]["ReportID"].ToString() + "' class='cbFilter'/>";
                else
                    dynTd1.InnerHtml = "<input type='checkbox' id='cbFilter_" + dt.Rows[i]["ReportID"].ToString() + "' class='cbFilter'/>";

                dynTd2.InnerText = dt.Rows[i]["ReportCaption"].ToString();
                dynTd3.InnerHtml = " <input type='text' style='width: 25px' id='txtFilterOrder_" + dt.Rows[i]["ReportID"].ToString() + "' value='" + dt.Rows[i]["ControlOrder"].ToString() + "'  class='txtFilterOrder'/>";

                dynTd4.InnerHtml = " <input type='text' style='width: 65px' id='txtFilterDefaltVal_" + dt.Rows[i]["ReportID"].ToString() + "' value='" + dt.Rows[i]["DefaltVal"].ToString() + "'  class='txtFilterOrder'/>";

                dynTrBody.Controls.Add(dynTd1);
                dynTrBody.Controls.Add(dynTd2);
                dynTrBody.Controls.Add(dynTd3);
                dynTrBody.Controls.Add(dynTd4);

                dynTBL.Controls.Add(dynTrBody);
            }
        }

        dFilterControls.Controls.Add(dynTBL);

        UpdatePaneldFilterControls.Update();
        upTabMSG.Update();
    }
}