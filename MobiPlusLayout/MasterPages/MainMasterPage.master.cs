using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Globalization;
using System.Threading;
using System.Net;

public partial class MasterPages_MainMasterPage : MasterPageBaseCls
{
    public string Lang = "";

    protected void Page_Init(object sender, EventArgs e)
    {
       
        if (SessionUserID == "0" && Request.QueryString["isTabletEnter"] == null || (Request.QueryString["isTabletEnter"] != null && Request.QueryString["isTabletEnter"].ToString() != "true"))
        {
            Response.Redirect("~/Login.aspx");
        }
        else if (Request.QueryString["isTabletEnter"] != null && Request.QueryString["isTabletEnter"].ToString() == "true")
        {
            //SessionUserID = "1";
            //SessionUserPromt = "ממשק אנדרואיד";
            //SessionGroupID = "3";
            //SessionVersionID = "0";
            //ProfileID = "3";
        }
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        Lang = SessionLanguage;
        // Set the culture to "Hebrew in Israel"
        CultureInfo cultureInfo = new CultureInfo("en-US");
        Thread.CurrentThread.CurrentCulture = cultureInfo;
      
        lblUser.Text = SessionUserPromt;
        if (!IsPostBack)
        {
            if (SessionGroupID != "4" && SessionGroupID != "3")//not admin
            {
            }
            lblProjectName.Text = SessionProjectName;
        }
    }
    protected void btnCheckSession_Click(object sender, EventArgs e)
    {
    }
    
    protected void lbtnHe_Click(object sender, EventArgs e)
    {
         MPUserChangeProfile(Context, SessionUserID, "He");
     
        Response.Redirect(Request.RawUrl);
    }

    protected void lbtnEn_Click(object sender, EventArgs e)
    {
        MPUserChangeProfile(Context, SessionUserID, "En");
        //Response.Redirect(Request.RawUrl);
        ScriptManager.RegisterClientScriptBlock(this.Page, typeof(Page), "gg3", "SetMenuClick();", true);
    }
    private void MPUserChangeProfile(HttpContext Context, string UserID, string Language)
    {
        WebClient client = new WebClient();

        string str = client.DownloadString("http://" + System.Configuration.ConfigurationManager.AppSettings["ServerAddress"].ToString() + "/MobiWebServices/MPLayoutService.asmx/MPUserChangeProfile?UserID=" + UserID + "&Language=" + Language +
            "&ConString=" + ConStrings.DicAllConStrings[SessionProjectName]);

        var objects = Newtonsoft.Json.Linq.JArray.Parse(HttpContext.Current.Server.UrlDecode(str));
        foreach (Newtonsoft.Json.Linq.JObject root in objects)
        {
            foreach (System.Collections.Generic.KeyValuePair<String, Newtonsoft.Json.Linq.JToken> app in root)
            {
               
                if (app.Key == "Language")
                {
                    SessionLanguage = ((string)app.Value).ToString();
                }
                if (app.Key == "ProfileID")
                {
                    SessionVersionID = ((int)app.Value).ToString();

                    if (System.Configuration.ConfigurationManager.AppSettings["IsDevelop"] != null && System.Configuration.ConfigurationManager.AppSettings["IsDevelop"].ToString().ToLower() == "true")
                    {
                        SessionVersionID = "0";
                    }

                }
                if (app.Key == "ProfileID")
                {
                    ProfileID = app.Value.ToString();
                }
                
            }
        }
    }
}
