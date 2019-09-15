using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Net.NetworkInformation;
using System.Configuration;

public partial class pages_GridRequests : PageBaseCls
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
        if (!IsPostBack)
        {
            init();
        }
    }
    public string GetMACAddress()
    {

        NetworkInterface[] nics = NetworkInterface.GetAllNetworkInterfaces();

        String sMacAddress = string.Empty;

        foreach (NetworkInterface adapter in nics)
        {

            if (sMacAddress == String.Empty)// only return MAC Address from first card  
            {

                IPInterfaceProperties properties = adapter.GetIPProperties();

                sMacAddress = adapter.GetPhysicalAddress().ToString();

            }

        } return sMacAddress;

    }
    private void init()
    {
        PushServerURL = ConfigurationManager.AppSettings["PushServerURL"].ToString();
        Comp = Session.SessionID;// GetMACAddress();

        Caption = "בקשות להרשאות";

        GridWidth = 0;
        colNames = "['','סטאטוס','תאריך','קוד עובד','שם עובד','קוד סוכן','סוכן','קוד פעילות','פעילות','קוד לקוח','לקוח','נושא','קוד מסמך','מסמך','הערת מנהל','הערות','styleicon1','','','']";
        
        
        colModel += "[{name: 'GridIcon', index:'GridIcon', width:30, sorttype:'text',formatter:   changeTitle},";
        colModel += "{name: 'RequestStatus', index:'RequestStatus', width:70, sorttype:'text'},";
        colModel += "{name: 'pTime', index:'pTime', width:150, sorttype:'date',formatter: 'date', formatoptions: { srcformat: 'ISO8601Long', newformat: 'H:i:s d/m/Y', defaultValue: null}},";
        colModel += "{name: 'EmployeeId', index:'EmployeeId', width:70, sorttype:'int'},";
        colModel += "{name: 'EmployeeName', index:'EmployeeName', width:100, sorttype:'text'},";
        colModel += "{name: 'AgentId', index:'AgentId', width:70, sorttype:'int'},";
        colModel += "{name: 'AgentName', index:'AgentName', width:120, sorttype:'text'},";
        colModel += "{name: 'ActivityCode', index:'ActivityCode', width:80, sorttype:'int'},";
        colModel += "{name: 'ActivityDescription', index:'ActivityDescription', width:140, sorttype:'text'},";
        colModel += "{name: 'Cust_Key', index:'Cust_Key', width:60, sorttype:'int'},";
        colModel += "{name: 'CustName', index:'CustName', width:80, sorttype:'text'},";
        colModel += "{name: 'SubjectDescription', index:'Comment', width:70, sorttype:'text'},";
        colModel += "{name: 'DocNum', index:'DocNum', width:70, sorttype:'int'},";
        colModel += "{name: 'DocName', index:'DocName', width:100, sorttype:'text'},";        
        colModel += "{name: 'ManagerComment', index:'ManagerComment', width:130,type:'text', sorttype:'text'},";
        colModel += "{name: 'Comment', index:'Comment', width:130, sorttype:'text'},";
        
        colModel += "{name: 'ManagerName', index:'ManagerName', width:0, sorttype:'text',hidden: true},";
        colModel += "{name: 'RequestID', index:'RequestID', width:0, type:'text', sorttype:'text',hidden: true},";
        colModel += "{name: 'Icon', index:'Icon', width:0, sorttype:'text',hidden: true},";
        colModel += "{name: 'styleicon1', index:'styleicon1', width:0, sorttype:'text',hidden: true}]";

        MainService.MobiPlusWS wr = new MainService.MobiPlusWS();
        ddlMainCon.DataSource = wr.GetManagerAuthorizationGroupActivitiesForWeb(SessionUserID);
        ddlMainCon.DataTextField = "ActivityDescription";
        ddlMainCon.DataValueField = "PermissionActivityCode";
        ddlMainCon.DataBind();

    }
}