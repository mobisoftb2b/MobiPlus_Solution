using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Pages_Compield_CustomersGrid : PageBaseCls
{
    public string Lang = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        Lang = SessionLanguage;

    }
}