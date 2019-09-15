using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Pages_Graphs_RGPaiView : System.Web.UI.Page
{
    public string iDate = "";
    public string AgentID = "";
    public string strWidth = "500";
    public string strHeight = "";
    public string strID = "";
    protected void Page_Load(object sender, EventArgs e)
    {

        if (!IsPostBack)
        {
            try
            {
                if (Request.QueryString["iDate"] != null)
                    iDate = Request.QueryString["iDate"].ToString();
                if (Request.QueryString["AgentID"] != null)
                    AgentID = Request.QueryString["AgentID"].ToString();
                if (Request.QueryString["ID"] != null)
                    strID = Request.QueryString["ID"].ToString();

                if (Session["isWinWidth1"] == null || (Session["isWinWidth1"] != null && (bool)Session["isWinWidth1"]) == false)
                {
                    ScriptManager.RegisterClientScriptBlock(this.Page, typeof(Page), "Reload", "DoStart();", true);
                    Session["isWinWidth1"] = true;
                    return;
                }
                Session["isWinWidth1"] = false;


                double width = Convert.ToDouble(Session["WinWidth"].ToString()) - 50;
                strHeight = Session["WinHeight"].ToString();
                //if (dt != null && dt.Rows.Count > 0)
                //{
                //    width = 85 * dt.Rows.Count + 200;
                //}
                strWidth = width.ToString();
                //sCanvas.InnerHtml = "<canvas id='Bar' width='" + width.ToString() + "' height='400'></canvas>";

            }
            catch (Exception)
            {
            }
        }
    }
}