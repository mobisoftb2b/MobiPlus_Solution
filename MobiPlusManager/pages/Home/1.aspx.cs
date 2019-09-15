using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Net.NetworkInformation;
using System.Configuration;

public partial class pages_1 : PageBaseCls
{
    public string colModel = "";
    public string colNames = "";
    public string Caption = "";
    public string GridName = "";
    public double GridWidth = 0;
    public string Comp="";
    public string PushServerURL = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        PushServerURL = ConfigurationManager.AppSettings["PushServerURL"].ToString();
        Comp = Session.SessionID;// GetMACAddress();

        Caption = "בקשות להרשאות";

        GridWidth = 0;
    }
    
}