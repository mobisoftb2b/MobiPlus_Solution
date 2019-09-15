using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

public partial class Pages_RPT_ShowFrame : PageBaseCls
{
    public string Params = "";
    public string Lang = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        Lang = SessionLanguage;
        if (!IsPostBack)
        {
            init();
        }
    }
    private void init()
    {
        if (Request.QueryString["ID"] != null)
        {
            Params = "";
            string[] arKeys = Request.QueryString.AllKeys;
            for (int i = 0; i < Request.QueryString.Count; i++)
            {
                if (arKeys[i] != "Width" && arKeys[i] != "Height" && arKeys[i] != "WinID" && arKeys[i].ToUpper() != "ID")
                    Params += "&" + arKeys[i] + "=" + Request.QueryString[i];
            }
            hdnSrcParams.Value = Params;

            MPLayoutService WR = new MPLayoutService();
            DataTable dt = WR.MPLayout_GetReportData(Request.QueryString["ID"].ToString(), SessionVersionID, ConStrings.DicAllConStrings[SessionProjectName], SessionLanguage);
            string script = "";
            if (dt != null && dt.Rows.Count > 0)
            {
                if (dt.Rows[0]["CompileActivityURL"].ToString() == "" && dt.Rows[0]["CompileActivityURL2"].ToString()=="")
                {
                    script = "setTimeout(\"ShowFrame('Rep_" + dt.Rows[0]["ReportTypeID"].ToString() + "', '" + Request.QueryString["ID"].ToString() + "');\",100);";
                    ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "script();", script, true);
                }
                else if (dt.Rows[0]["CompileActivityURL2"].ToString() == "")
                {
                    Response.Redirect(dt.Rows[0]["CompileActivityURL"].ToString());
                }
                else
                {
                    Response.Redirect(dt.Rows[0]["CompileActivityURL2"].ToString());
                }
            }
        }
    }
}