using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

public partial class Graphs_Default : PageBaseCls
{
    public string iDate = "";
    public string AgentID = "";
    public string strWidth = "";
    public string strHeight = "400";
    public string strID = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            try
            {
                if (Session["isWinWidth3"] == null || (Session["isWinWidth3"] != null && (bool)Session["isWinWidth3"]) == false)
                {
                    ScriptManager.RegisterClientScriptBlock(this.Page, typeof(Page), "Reload" + DateTime.Now.Ticks.ToString(), "setTimeout(DoStart,1000);setTimeout(DoStart,2000);setTimeout(DoStart,3000);", true);
                    Session["isWinWidth3"] = true;
                    return;
                }
                Session["isWinWidth3"] = false;
                if (Request.QueryString["iDate"] != null)
                    iDate = Request.QueryString["iDate"].ToString();
                if (Request.QueryString["AgentID"] != null)
                    AgentID = Request.QueryString["AgentID"].ToString();
                if (Request.QueryString["ID"] != null)
                    strID = Request.QueryString["ID"].ToString();

                MainService.MobiPlusWS wr = new MainService.MobiPlusWS();
                DataTable dt = wr.GetAgentSalesGraphDT(iDate, AgentID, ConStrings.DicAllConStrings[SessionProjectName]);

                double width = Convert.ToDouble(Session["WinWidth"].ToString()) - 50;
                double height = Convert.ToDouble(Session["WinHeight"].ToString()) - 50;
                strHeight = height.ToString();
                if (dt != null && dt.Rows.Count > 0)
                {
                    width = 85 * dt.Rows.Count + 200;
                }
                strWidth = width.ToString();
                //sCanvas.InnerHtml = "<canvas id='Bar' width='" + width.ToString() + "' height='400'></canvas>";

            }
            catch (Exception)
            {
            }
        }
    }
}