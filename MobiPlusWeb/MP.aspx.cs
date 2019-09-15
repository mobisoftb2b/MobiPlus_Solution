using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class MP : System.Web.UI.Page
{
    private static Dictionary<string,string> dicAllLog;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if(dicAllLog==null)
                dicAllLog = new Dictionary<string,string>();

            setPoint();
        }
        ShowLog();
    }
    protected void btnRefresh_Click(object sender, EventArgs e)
    {
    }
    private void setPoint()
    {
        int index = dicAllLog.Count;
        if (index < 0)
            index = 0;

        string IP = Request.UserHostAddress;
        string Name = "";
        if (Request.QueryString["Name"] != null)
            Name = Request.QueryString["Name"].ToString();

        dicAllLog.Add(index.ToString(), "IP: " + IP +"; Name: "+Name + "; Date Time: "+DateTime.Now.ToString("dd/MM/yyyy HH:mm:ss"));
    }
    private void ShowLog()
    {
        dLog.Controls.Clear();

        string scr = "<table>";

        for (int i = 0; i < dicAllLog.Count; i++)
        {
            scr += "<tr>";
            scr += "<td>";
            scr += dicAllLog[i.ToString()];
            scr += "</td>";
            scr += "</tr>";
        }

        scr += "</table>";

        dLog.InnerHtml = scr;
    }
}