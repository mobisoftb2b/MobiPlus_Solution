using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class tests_UpdateCache : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void btn_Click(object sender, EventArgs e)
    {
        try
        {

            MPService.MobiPlusService wr = new MPService.MobiPlusService();
            wr.UpdateCache_ServerPushFiles();
        }
        catch(Exception ex)
        {
        }
    }
}