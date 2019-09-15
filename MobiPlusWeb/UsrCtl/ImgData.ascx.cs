using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class ImgData : System.Web.UI.UserControl
{
    public string Text
    {
        get
        {
            return lblText.Text;
        }
        set
        {
            lblText.Text = value;
        }
    }
    protected void Page_Load(object sender, EventArgs e)
    {

    }
}