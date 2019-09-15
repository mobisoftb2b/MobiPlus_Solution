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

public partial class Pages_RPT_ShowGrafPie : PageBaseCls
{
    public string strID = "";
    public string ReportID = "";
    public string Width = "";
    public string Height = "";
    public string WinID = "";
    public string Params = "";
    public string GrafData = "";

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
        
        //Width = (Convert.ToDouble(Width) - 35).ToString();
        Height = (Convert.ToDouble(Height) ).ToString();

        WebClient client = new WebClient();
        GrafData = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MPLayoutService.asmx/GetPieRep?GraphID=" + ReportID + "&VersionID=" + SessionVersionID + "&arrParms=" + Params +
            "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);

        GrafData = HttpContext.Current.Server.UrlDecode(GrafData);
        
    }
}