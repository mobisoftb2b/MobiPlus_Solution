using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

public partial class Pages_Admin_GridsEdit : PageBaseCls
{
    public string colModel = "";
    public string colNames = "";
    public string Caption = "";
    public string GridName = "";
    public double GridWidth = 0;
    public string GridParameters = "";



    public string strGridColID = "0";

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            init();
        }
    }
    private void init()
    {
        MainService.MobiPlusWS wr = new MainService.MobiPlusWS();

        DataTable dt = wr.GetQueryTypes();
         
        ddlQueryType.DataSource = dt;
        ddlQueryType.DataTextField = "QueryType";
        ddlQueryType.DataValueField = "id";
        ddlQueryType.DataBind();

        ddlGraphType.DataSource = wr.GetGraphTypes();
        ddlGraphType.DataTextField = "GraphType";
        ddlGraphType.DataValueField = "id";
        ddlGraphType.DataBind();
    }
}
