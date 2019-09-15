using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Net;
using System.Runtime.Serialization.Json;
using System.Runtime.Serialization;
using System.IO;

public partial class Pages_RPT_ShowGrafClock : PageBaseCls
{
    public string strID = "";
    public string ReportID = "";
    public string Width = "";
    public string Height = "";
    public string WinID = "";
    public string Params = "";
    public string Caption = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Request.QueryString["ID"] != null)
                ReportID = Request.QueryString["ID"].ToString();

            if (Request.QueryString["Width"] != null)
                Width = Request.QueryString["Width"].ToString();

            if (Request.QueryString["Height"] != null)
                Height = Request.QueryString["Height"].ToString();

            if (Request.QueryString["WinID"] != null)
                WinID = Request.QueryString["WinID"].ToString();

            init();
        }
    }
    private void init()
    {
        Params = "";
        string[] arKeys = Request.QueryString.AllKeys;
        for (int i = 0; i < Request.QueryString.Count; i++)
        {
            if (arKeys[i] != "Width" && arKeys[i] != "Height" && arKeys[i] != "WinID")
                Params += arKeys[i] + "=" + Request.QueryString[i] + ";";
        }

        Width = (Convert.ToDouble(Width)/1.5).ToString();
        //Height = (Convert.ToDouble(Height) - 135).ToString();

        MPLayoutService.MPLayoutService WR = new MPLayoutService.MPLayoutService();
        DataTable dt = WR.GetMeterChart(ReportID, SessionVersionID, ConStrings.DicAllConStrings[SessionProjectName], Params);

        if (dt != null && dt.Rows.Count > 0)
        {
            Caption = dt.Rows[0]["Caption"].ToString();
            //setGraph(0, data1.responseJSON[0].MaxSumSales / 1000, data1.responseJSON[0].SumSales / 1000);
            if (dt.Rows[0]["MaxSumSales"].ToString() != "" && dt.Rows[0]["SumSales"].ToString() != "")
            {
                string scr = "setTimeout('setGraph(0, " + (Convert.ToDouble(dt.Rows[0]["MaxSumSales"].ToString()) / 1000).ToString() + ", " + (Convert.ToDouble(dt.Rows[0]["SumSales"].ToString()) / 1000).ToString() + ")',100);";
                ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "scr();" + DateTime.Now.Ticks.ToString(), scr, true);
            }
            
        }

        
    }
}