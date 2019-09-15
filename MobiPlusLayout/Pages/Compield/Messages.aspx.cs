using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Pages_Compield_Messages : PageBaseCls
{
    public string Lang = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        Lang = SessionLanguage;

        if (!IsPostBack)
        {
            init();
        }
    }
    private void init()
    {
        if (Request.QueryString["Agents"] != null && Request.QueryString["Agents"].ToString() == "true")
            ctlPopulationsR.ShowCustomers = false;
        else
            ctlPopulationsR.ShowAgents = false;
    }
}