using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MainService;
using System.Data;
using System.Web.UI.HtmlControls;

public partial class Pages_Admin_EditPrnPart : PageBaseCls
{
    public string LayoutTypeID = "1";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Request.QueryString["LayoutTypeID"] != null)
                LayoutTypeID = Request.QueryString["LayoutTypeID"].ToString();
            init();
            initImgs();
        }
    }
    protected void btnRefreshDDLQueries_click(object sender, EventArgs e)
    {
        if (Request.QueryString["LayoutTypeID"] != null)
            LayoutTypeID = Request.QueryString["LayoutTypeID"].ToString();
        InitPrn_ddlQueries();
    }
    protected void btnRefreshddlParts_click(object sender, EventArgs e)
    {
        if (Request.QueryString["LayoutTypeID"] != null)
            LayoutTypeID = Request.QueryString["LayoutTypeID"].ToString();
        InitPrn_ddlParts();
    }
    private void init()
    {
        MobiPlusWS WR = new MobiPlusWS();

        InitPrn_ddlParts();

        DataTable dt2 = WR.Prn_GetPartTypes(ConStrings.DicAllConStrings[SessionProjectName]);
        if (dt2 != null)
        {
            ddlPartTypes.DataSource = dt2;
            ddlPartTypes.DataTextField = "PartTypeName";
            ddlPartTypes.DataValueField = "idPartType";
            ddlPartTypes.DataBind();

            ddlEditColTypeID.DataSource = dt2;
            ddlEditColTypeID.DataTextField = "PartTypeName";
            ddlEditColTypeID.DataValueField = "idPartType";
            ddlEditColTypeID.DataBind();
        }

        DataTable dtTopics = WR.Prn_GetTopics(ConStrings.DicAllConStrings[SessionProjectName]);
        if (dtTopics != null)
        {
            ddlTopics.DataSource = dtTopics;
            ddlTopics.DataTextField = "Topic";
            ddlTopics.DataValueField = "TopicID";
            ddlTopics.DataBind();
        }

        DataTable dt21 = WR.Prn_GetColTypes(ConStrings.DicAllConStrings[SessionProjectName]);
        if (dt21 != null)
        {
            ddlEditColTypeID.DataSource = dt21;
            ddlEditColTypeID.DataTextField = "TypeName";
            ddlEditColTypeID.DataValueField = "ColTypeID";
            ddlEditColTypeID.DataBind();
        }

        InitPrn_ddlQueries();

        DataSet ds = WR.Prn_GetPartColsDDLs(ConStrings.DicAllConStrings[SessionProjectName]);
        if (ds != null && ds.Tables[0] != null)
        {
            ddlEditColFormatID.DataSource = ds.Tables[0];
            ddlEditColFormatID.DataTextField = "FormatString";
            ddlEditColFormatID.DataValueField = "FormatID";
            ddlEditColFormatID.DataBind();
        }

        if (ds != null && ds.Tables[1] != null)
        {
            ddlEditColAlignmentID.DataSource = ds.Tables[1];
            ddlEditColAlignmentID.DataTextField = "Alignment";
            ddlEditColAlignmentID.DataValueField = "AlignmentID";
            ddlEditColAlignmentID.DataBind();
        }

        if (ds != null && ds.Tables[2] != null)
        {
            ddlEditColStyleID.DataSource = ds.Tables[2];
            ddlEditColStyleID.DataTextField = "StyleName";
            ddlEditColStyleID.DataValueField = "StyleID";
            ddlEditColStyleID.DataBind();
        }

        if (ds != null && ds.Tables[3] != null)
        {
            ddlNewrow.DataSource = ds.Tables[3];
            ddlNewrow.DataTextField = "NewRowText";
            ddlNewrow.DataValueField = "NewRowID";
            ddlNewrow.DataBind();
        }
        /*SELECT NewRowID
	  ,NewRowText
	FROM dbo.Prn_NewRowTypes
	ORDER BY NewRowID*/
    }
    private void InitPrn_ddlQueries()
    {
        MobiPlusWS WR = new MobiPlusWS();
        DataTable dt3 = WR.Prn_GetQueries(ConStrings.DicAllConStrings[SessionProjectName]);
        if (dt3 != null)
        {
            ddlQueries.DataSource = dt3;
            ddlQueries.DataTextField = "QueryName";
            ddlQueries.DataValueField = "idQuery";
            ddlQueries.DataBind();

            try
            {
                if (hdnQueryID.Value != "")
                    ddlQueries.SelectedValue = hdnQueryID.Value;
            }
            catch (Exception ex)
            {
                 ddlQueries.SelectedValue="0";
            }

        }
    }
    private void InitPrn_ddlParts()
    {
        MobiPlusWS WR = new MobiPlusWS();
        DataTable dt = WR.Prn_GetPartsForDDL(ConStrings.DicAllConStrings[SessionProjectName]);
        if (dt != null)
        {
            ddlParts.DataSource = dt;
            ddlParts.DataTextField = "PartName";
            ddlParts.DataValueField = "idPart";
            ddlParts.DataBind();

            try
            {
                if (hdnPartID.Value != "")
                    ddlParts.SelectedValue = hdnPartID.Value;
                else
                {
                    ddlParts.SelectedValue = Request.QueryString["ID"].ToString();
                    ScriptManager.RegisterClientScriptBlock(this.Page, typeof(Page), "setNew1", "setTimeout('setNew();',100);setTimeout('GetPartData(" + Request.QueryString["ID"].ToString() + ")',100);", true);

                }
            }
            catch (Exception ex)
            {
                ddlParts.SelectedValue = "0";
            }
        }
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