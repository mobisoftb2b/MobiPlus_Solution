using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Web.UI.HtmlControls;

public partial class Pages_Admin_EditImages : PageBaseCls
{
    public string LayoutTypeID = "1";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Request.QueryString["LayoutTypeID"] != null)
                LayoutTypeID = Request.QueryString["LayoutTypeID"].ToString();

            initImgs();
        }
    }
    protected void btnUploadImg_Click(object sender, EventArgs e)
    {
        if (Request.QueryString["LayoutTypeID"] != null)
            LayoutTypeID = Request.QueryString["LayoutTypeID"].ToString();
        SetImg();
    }
    private void SetImg()
    {
        Session["imgFromImages"] = fuImg.FileBytes;
        Session["FileNameFromImages"] = fuImg.FileName;

        ScriptManager.RegisterClientScriptBlock(this.Page, typeof(Page), "ShowImgFormUpload", "setTimeout('ShowImgFormUpload();',200);",true);
    }
    private void initImgs()
    {
        MainService.MobiPlusWS wr = new MainService.MobiPlusWS();
        DataTable dt = wr.Layout_GetAllImages(ConStrings.DicAllConStrings[SessionProjectName], LayoutTypeID);
        if (dt != null && dt.Rows.Count > 0)
        {
            //dAllImgs
            HtmlGenericControl dynTBLAll = new HtmlGenericControl("table");
            dynTBLAll.Attributes["cellpadding"] = "2";
            dynTBLAll.Attributes["cellspacing"] = "2";
            dynTBLAll.Style["min-height"] = "150px";


            HtmlGenericControl dynTR = new HtmlGenericControl("tr");

            for (int i = 0; i < dt.Rows.Count; i++)
            {
                HtmlGenericControl dynTD = new HtmlGenericControl("td");
                dynTD.InnerHtml = dt.Rows[i]["ImgName"].ToString() + "<br/><br/>";
                dynTD.Style["width"] = "100px";
                dynTD.Style["border"] = "1px solid black";
                dynTD.Style["text-align"] = "center";
                dynTD.Style["background-color"] = "white";
                dynTD.Style["cursor"] = "pointer";
                dynTD.Attributes["onclick"] = "SetImg('" + dt.Rows[i]["ImgID"].ToString() + "');";
                Image img = new Image();
                img.ImageUrl = "~/Handlers/ShowImage.ashx?id=" + dt.Rows[i]["ImgID"].ToString();
                img.Style["max-width"] = "100px";

                dynTD.Controls.Add(img);

                HtmlGenericControl dynDiv = new HtmlGenericControl("div");
                dynDiv.Style["text-align"] = "left";
                dynDiv.InnerHtml = "<br/>Width: " + dt.Rows[i]["imgWidth"].ToString() + "<br/>Height: " + dt.Rows[i]["imgHeight"].ToString() + "<br/>";

                dynTD.Controls.Add(dynDiv);

                dynTR.Controls.Add(dynTD);
                if ((i + 1) % 4 == 0)
                {
                    dynTBLAll.Controls.Add(dynTR);
                    dynTR = new HtmlGenericControl("tr");
                }
            }

            dynTBLAll.Controls.Add(dynTR);
            dAllImgs.Controls.Add(dynTBLAll);
        }
    }
}