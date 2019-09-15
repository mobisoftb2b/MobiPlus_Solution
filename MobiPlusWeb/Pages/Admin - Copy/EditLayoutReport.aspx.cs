using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Pages_Admin_EditLayoutReport : PageBaseCls
{
    public string LayoutTypeID = "1";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Request.QueryString["LayoutTypeID"] != null)
                LayoutTypeID = Request.QueryString["LayoutTypeID"].ToString();
        }
    }
}