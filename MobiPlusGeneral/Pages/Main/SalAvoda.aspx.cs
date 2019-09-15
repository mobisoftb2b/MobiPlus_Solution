using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Pages_Main_SalAvoda : PageBaseCls
{
    public string AgentId = "0";
    public string DateMap = "01/01/2000";
    public string DateData = "20000101";

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            init();
        }
    }
    private void init()
    {
        if (Request.QueryString["User"] != null && Request.QueryString["date"] != null)
        {
            DateData = Request.QueryString["date"].ToString();
            DateMap = Request.QueryString["date"].ToString().Substring(6, 2) + "/" + Request.QueryString["date"].ToString().Substring(4, 2) + "/" + Request.QueryString["date"].ToString().Substring(0, 4);
            AgentId = Request.QueryString["user"].ToString();
        }
    }
}