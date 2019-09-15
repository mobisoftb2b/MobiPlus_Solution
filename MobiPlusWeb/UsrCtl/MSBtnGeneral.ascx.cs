using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class UsrCtl_MSBtnOK : System.Web.UI.UserControl
{
    public event EventHandler Click;
    

    public string Text
    {
        get
        {
            if (ViewState["Text"] == null)
                ViewState["Text"] = "אישור";
            return ViewState["Text"].ToString();
        }
        set
        {
            ViewState["Text"] = value;
        }
    }
    public string Width
    {
        get
        {
            if (ViewState["Width"] == null)
                ViewState["Width"] = "85px";
            return ViewState["Width"].ToString();
        }
        set
        {
            ViewState["Width"] = value;
        }
    }
    public string ImgURL
    {
        get
        {
            if (ViewState["ImgURL"] == null)
                ViewState["ImgURL"] = "";
            return ViewState["ImgURL"].ToString();
        }
        set
        {
            ViewState["ImgURL"] = value;
        }
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            MSBtnGeneral.Style["width"] = Width;
            MSBtnGeneral.Style["background-image"] = ImgURL;
        }
    }
    protected void ServerClick(object sender, EventArgs e)
    {
        if (this.Click != null)
        {
            this.Click(sender, e);
        }
    }
}