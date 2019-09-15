using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Pages_Admin_EditFragments : PageBaseCls
{
    public string LayoutTypeID = "3";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            init();
        }
    }
    protected void btnRefreshSections_Click(object sender, EventArgs e)
    {
        initDDlSections();
    }
    protected void btnRefreshddlFragments_Click(object sender, EventArgs e)
    {
        initddlFragments();
        ScriptManager.RegisterClientScriptBlock(this.Page,typeof(Page),"Load"+DateTime.Now.Ticks.ToString(), "LoadAgain();",true);
    }
    private void initDDlSections()
    {
        MainService.MobiPlusWS wr = new MainService.MobiPlusWS();
        ddlSections.DataSource = wr.Frg_GetDDLSections(ConStrings.DicAllConStrings[SessionProjectName]);
        ddlSections.DataTextField = "SectionName";
        ddlSections.DataValueField = "SectionID";
        ddlSections.DataBind();
        ddlSections.SelectedValue = "0";

        ddlSectionsForAdd.DataSource = wr.Frg_GetDDLSections(ConStrings.DicAllConStrings[SessionProjectName]);
        ddlSectionsForAdd.DataTextField = "SectionName";
        ddlSectionsForAdd.DataValueField = "SectionID";
        ddlSectionsForAdd.DataBind();
        if (ddlSectionsForAdd.Items.Count > 0)
            ddlSectionsForAdd.Items.RemoveAt(0);


        ScriptManager.RegisterClientScriptBlock(this.Page, typeof(Page), "GetSectionData" + DateTime.Now.Ticks.ToString(), "GetSectionData();", true); 
    }
    private void initddlFragments()
    {
        MainService.MobiPlusWS wr = new MainService.MobiPlusWS();
        ddlFragments.DataSource = wr.Frg_GetDDLFrgments(ConStrings.DicAllConStrings[SessionProjectName]);
        ddlFragments.DataTextField = "FragmentName";
        ddlFragments.DataValueField = "FragmentID";
        ddlFragments.DataBind();
        ddlFragments.SelectedValue = "0";
    }
    private void init()
    {
        initDDlSections();

        MainService.MobiPlusWS wr = new MainService.MobiPlusWS();

        ddlSectionTypes.DataSource = wr.Frg_GetDDLSectionTypes(ConStrings.DicAllConStrings[SessionProjectName]);
        ddlSectionTypes.DataTextField = "TypeName";
        ddlSectionTypes.DataValueField = "SectionTypeID";
        ddlSectionTypes.DataBind();

        ddlAlign.DataSource = wr.Frg_GetDDLSectionAligns(ConStrings.DicAllConStrings[SessionProjectName]);
        ddlAlign.DataTextField = "Alignment";
        ddlAlign.DataValueField = "AlignmentID";
        ddlAlign.DataBind();

        ddlStyles.DataSource = wr.Frg_GetDDLSectionStyles(ConStrings.DicAllConStrings[SessionProjectName]);
        ddlStyles.DataTextField = "StyleName";
        ddlStyles.DataValueField = "StyleID";
        ddlStyles.DataBind();

        ddlFormats.DataSource = wr.Frg_GetDDLSectionFormats(ConStrings.DicAllConStrings[SessionProjectName]);
        ddlFormats.DataTextField = "FormatString";
        ddlFormats.DataValueField = "FormatID";
        ddlFormats.DataBind();

        //DataTable dtPr = wr.Frg_GetDDLProfiles("3", ConStrings.DicAllConStrings[SessionProjectName]);
        //if(dtPr!=null)
        //{
        //    for (int i = 0; i < dtPr.Rows.Count; i++)
        //    {
        //        ddlProfiles.Items.Add(new ListItem(dtPr.Rows[i]["ProfileID"].ToString()+" - "+dtPr.Rows[i]["ProfileName"].ToString(), dtPr.Rows[i]["ProfileID"].ToString()));
        //    }
        //}
        //ddlFrgReports.DataSource = wr.Layout_GetReports(ConStrings.DicAllConStrings[SessionProjectName], "3");
        //ddlFrgReports.DataTextField = "ReportName";        
        //ddlFrgReports.DataValueField = "ReportID";
        //ddlFrgReports.DataBind();

        initddlFragments();
    }



}