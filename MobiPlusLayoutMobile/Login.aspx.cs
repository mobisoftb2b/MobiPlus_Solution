using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Configuration;
using System.Web.UI.HtmlControls;


public partial class Login : PageBaseCls
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            init();
        }
        
    }
    private void init()
    {
        Session.Clear();
        Session.Abandon();
        SessionLanguage = "Hebrew";

        //projects
        string[] arr = ConStrings.DicAllConStrings.Keys.ToArray<string>();
        if (ConStrings.DicAllConStrings != null)
        {
            if (ConStrings.DicAllConStrings.Keys.Count == 1)//only one
            {
                SessionProjectName = arr[0];
                divAllProjects.Visible = false;
                ScriptManager.RegisterClientScriptBlock(this.Page,typeof(Page),"jkey1","$('#dBody').unblock();",true);
            }
            else
            {
                ScriptManager.RegisterClientScriptBlock(this.Page, typeof(Page), "jkey5441", " $('#dBody').block({ message: '' });", true);
                for (int i = 0; i < arr.Length; i++)
                {
                    HtmlGenericControl dynDiv = new HtmlGenericControl("div");
                    dynDiv.Attributes["class"] = "prItem";
                    dynDiv.Attributes["onclick"] = "SetProjectName('" + arr[i] + "');";
                    dynDiv.InnerText = arr[i];
                    divAllProjects.Controls.Add(dynDiv);
                }
            }
        }
        //end projects
    }
}