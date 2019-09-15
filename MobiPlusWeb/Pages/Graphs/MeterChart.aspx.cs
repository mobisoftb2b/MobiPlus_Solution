using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

public partial class Pages_Graphs_HBarView : System.Web.UI.Page
{
    public string iDate = "";
    public string AgentID = "";
    public string strWidth = "500";
    public string strHeight = "400";
    public string strID = "";
    public string Caption = "";
    public string maxScale = "10000000";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            try
            {
                //if (Session["isWinWidth27"] == null || (Session["isWinWidth27"] != null && (bool)Session["isWinWidth27"]) == false)
                //{
                //    ScriptManager.RegisterClientScriptBlock(this.Page, typeof(Page), "Reload" + DateTime.Now.Ticks.ToString(), "DoStart();", true);
                //    Session["isWinWidth27"] = true;
                //    return;
                //}
                //Session["isWinWidth27"] = false;
                //if (Request.QueryString["iDate"] != null)
                //    iDate = Request.QueryString["iDate"].ToString();
                //if (Request.QueryString["AgentID"] != null)
                //    AgentID = Request.QueryString["AgentID"].ToString();
                if (Request.QueryString["ID"] != null)
                    strID = Request.QueryString["ID"].ToString();
                if (Request.QueryString["iDate"] != null)
                    iDate = Request.QueryString["iDate"].ToString();
                if (Request.QueryString["AgentID"] != null)
                {
                    AgentID = Request.QueryString["AgentID"].ToString();
                    AgentID = AgentID.Split(',')[0];
                }
                if(Request.QueryString["Caption"] != null)
                {
                    Caption = Request.QueryString["Caption"].ToString();
                }
                //MainService.MobiPlusWS wr = new MainService.MobiPlusWS();
                //DataTable dt = wr.GetRGHBarDataDT(Request.QueryString["GraphID"].ToString(), Request.QueryString["GridParameters"].ToString());

                //double h = 450;
                //strHeight = (Convert.ToDouble(Session["WinHeight27"].ToString())-50).ToString();
                //if (dt != null && dt.Rows.Count > 0)
                //{
                //    h = 70 * dt.Rows.Count + 100;
                //    double mScale = 0;
                //    for (int i = 0; i < dt.Rows.Count; i++)
                //    {
                //        if (Convert.ToDouble(dt.Rows[0]["Total"].ToString()) > mScale)
                //            mScale = Convert.ToDouble(dt.Rows[0]["Total"].ToString()) + 100;
                        
                //    }
                //    maxScale = (mScale*5).ToString();
                //}
                //strHeight = h.ToString();
                //strWidth = width.ToString();
            }
            catch (Exception)
            {
            }
        }
    }
}