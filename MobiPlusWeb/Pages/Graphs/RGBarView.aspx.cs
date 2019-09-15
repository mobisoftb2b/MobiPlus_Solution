using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

public partial class Pages_Graphs_RGBarView : PageBaseCls
{
    public string iDate = "";
    public string AgentID = "";
    public string strWidth = "4500";
    public string strHeight = "400";
    public string strID = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            try
            {
                if (Session["isWinWidth27"] == null || (Session["isWinWidth27"] != null && (bool)Session["isWinWidth27"]) == false)
                {
                    ScriptManager.RegisterClientScriptBlock(this.Page, typeof(Page), "Reload" + DateTime.Now.Ticks.ToString(), "DoStart();", true);
                    Session["isWinWidth27"] = true;
                    return;
                }
                Session["isWinWidth27"] = false;
                if (Request.QueryString["iDate"] != null)
                    iDate = Request.QueryString["iDate"].ToString();
                if (Request.QueryString["AgentID"] != null)
                    AgentID = Request.QueryString["AgentID"].ToString();
                if (Request.QueryString["ID"] != null)
                    strID = Request.QueryString["ID"].ToString();

                MainService.MobiPlusWS wr = new MainService.MobiPlusWS();
                DataTable dt = wr.GetSPData(Request.QueryString["GraphID"].ToString(), iDate, AgentID, ConStrings.DicAllConStrings[SessionProjectName]);

                double width = 500;
                //strHeight = (Convert.ToDouble(Session["WinHeight27"].ToString())-50).ToString();
                if (dt != null && dt.Rows.Count > 0)
                {
                    width = 50 * dt.Rows.Count + 200;
                }
                strWidth = width.ToString();
            }
            catch (Exception)
            {
            }
        }
    }
}