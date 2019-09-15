using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Globalization;
using System.Threading;

public partial class MasterPages_MainMasterPage : MasterPageBaseCls
{


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
        // Set the culture to "Hebrew in Israel"
        CultureInfo cultureInfo = new CultureInfo("he-IL");
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

}
