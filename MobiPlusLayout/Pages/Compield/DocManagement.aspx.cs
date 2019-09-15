using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Pages_Compield_DocManagement : PageBaseCls
{
    public static string GeneralDir = "";
    public static string FilePrefixes = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (System.Configuration.ConfigurationManager.AppSettings["DocManagementDir"] != null)
            GeneralDir = System.Configuration.ConfigurationManager.AppSettings["DocManagementDir"].ToString();

        if (System.Configuration.ConfigurationManager.AppSettings["DocManagementPrfixes"] != null)
            FilePrefixes = System.Configuration.ConfigurationManager.AppSettings["DocManagementPrfixes"].ToString();

        init();

        GetDirObjs(GeneralDir, FilePrefixes);
    }
    protected void FileUpload_Click(object sender, EventArgs e)
    {
        if (hdnIsUpload.Value == "1")
        {
            hdnIsUpload.Value = "0";
            FileUpload();
        }
    }
    private void init()
    {
        try
        {
            MPLayoutService wr = new MPLayoutService();
            StringBuilder sb = new StringBuilder();
            StringBuilder sbFilter = new StringBuilder();

            if (Request.QueryString["Oc"].ToString().StartsWith("true"))
            {
                hdnObjectsTypeID.Value = "1";


                DataTable dt = wr.MPLayout_GetDocsManagementPopulations(ConStrings.DicAllConStrings[SessionProjectName]);
                if (dt != null)
                {
                    sbFilter.Append("<select class='ddlFilter' size='30' onchange='setFilter(this.value);'>");
                    sbFilter.Append("<option selected value='0'>הכל</option>");
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        sb.Append("<input type='checkbox' id='cb_" + i.ToString() + "' value='" + dt.Rows[i]["ID"].ToString() + "' class='OCT' />");
                        sb.Append("<lable for='cb_" + i.ToString() + "'>" + dt.Rows[i]["Name"].ToString() + "</lable>");
                        sb.Append("<br/>");

                        sbFilter.Append("<option value='"+ dt.Rows[i]["Name"].ToString() + "'>"+ dt.Rows[i]["Name"].ToString() + "</option>");
                    }
                    sbFilter.Append("</select>");
                }
            }
            else if (Request.QueryString["Oc"].ToString().StartsWith("false"))
            {
                hdnObjectsTypeID.Value = "2";


                DataTable dt = wr.MPLayout_GetDocsManagementCustomers(ConStrings.DicAllConStrings[SessionProjectName]);
                if (dt != null)
                {
                    sbFilter.Append("<select class='ddlFilter' size='30' onchange='setFilter(this.value);'>");
                    sbFilter.Append("<option selected value='0'>הכל</option>");
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        sb.Append("<input type='checkbox' id='cb_" + i.ToString() + "' value='" + dt.Rows[i]["ID"].ToString() + "' class='OCT' />");
                        sb.Append("<lable for='cb_" + i.ToString() + "'>" + dt.Rows[i]["Name"].ToString() + "</lable>");
                        sb.Append("<br/>");

                        sbFilter.Append("<option value='" + dt.Rows[i]["Name"].ToString() + "'>" + dt.Rows[i]["Name"].ToString() + "</option>");
                    }
                    sbFilter.Append("</select>");
                }
            }
            dOC.InnerHtml = sb.ToString();
            dFilter.InnerHtml = sbFilter.ToString();
        }
        catch (Exception ex)
        {

        }

        //MPLayout_GetDocsManagementPopulations
    }

    private void FileUpload()
    {
        try {
            byte[] bFile = FileUpload1.FileBytes;
            if (bFile.Length > 0)
            {
                string FileName = FileUpload1.FileName;
                File.WriteAllBytes(GeneralDir + FileName, bFile);

                GetDirObjs(GeneralDir, FilePrefixes);
            }
        }
        catch(Exception ex)
        {
            MobiPlusTools.Tools.HandleError(ex, System.Configuration.ConfigurationManager.AppSettings["LogDirectory"].ToString(), SessionUserID, SessionUserPromt);
        }
        //ScriptManager.RegisterClientScriptBlock(this.Page,typeof(Page),"gg"+DateTime.Now.Ticks.ToString(), "setTimeout('SetD();',1000);",true);
    }

    private void GetDirObjs(string generalDir, string filePrefixes)
    {
        dDir.InnerHtml = "";
        StringBuilder sb = new StringBuilder();
        StringBuilder sbIn = new StringBuilder();
        StringBuilder sbOc = new StringBuilder();

        string strObjectsTypeID = "1";
        if (Request.QueryString["Oc"].ToString().StartsWith("false"))
            strObjectsTypeID = "2";

        MPLayoutService wr = new MPLayoutService();
        DataSet ds = wr.MPLayout_GetDocsManagementData(strObjectsTypeID , ConStrings.DicAllConStrings[SessionProjectName]);

        if (ds != null && ds.Tables.Count > 1)
        {
            DataTable dt = null;
            if (Request.QueryString["Oc"].ToString().StartsWith("true"))
                dt = wr.MPLayout_GetDocsManagementPopulations(ConStrings.DicAllConStrings[SessionProjectName]);
            else if (Request.QueryString["Oc"].ToString().StartsWith("false"))
                dt = wr.MPLayout_GetDocsManagementCustomers(ConStrings.DicAllConStrings[SessionProjectName]);
            if (dt != null)
            {

                for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                {

                    sbIn = new StringBuilder();
                    sbOc = new StringBuilder();
                    for (int t = 0; t < ds.Tables[1].Rows.Count; t++)
                    {
                        if (ds.Tables[1].Rows[t]["DocManagementID"].ToString() == ds.Tables[0].Rows[i]["DocManagementID"].ToString())
                        {
                            DataView dv = dt.DefaultView;
                            dv.RowFilter = "ID = " + ds.Tables[1].Rows[t]["ObjectID"].ToString();
                            DataTable newDT = dv.ToTable();
                            if (newDT != null && newDT.Rows.Count > 0)
                                sbIn.Append(newDT.Rows[0]["Name"].ToString());

                            //if (ds.Tables[1].Rows[t]["ObjectID"].ToString() == "1")
                            //    sbIn.Append("שופרסל");
                            //else if (ds.Tables[1].Rows[t]["ObjectID"].ToString() == "2")
                            //    sbIn.Append("מגה");
                            //else if (ds.Tables[1].Rows[t]["ObjectID"].ToString() == "3")
                            //    sbIn.Append("יינות ביתן");
                            //else if (ds.Tables[1].Rows[t]["ObjectID"].ToString() == "4")
                            //    sbIn.Append("רמי לוי");
                            //else if (ds.Tables[1].Rows[t]["ObjectID"].ToString() == "5")
                            //    sbIn.Append("טיב טעם");

                            sbIn.Append(", ");

                            sbOc.Append(ds.Tables[1].Rows[t]["ObjectID"].ToString());
                            sbOc.Append(",");
                        }
                    }

                    sb.Append("<div class='DocMFile' style=\"background-image: url('../../Img/docs/" + ds.Tables[0].Rows[i]["FileName"].ToString().Substring(ds.Tables[0].Rows[i]["FileName"].ToString().IndexOf(".") + 1, ds.Tables[0].Rows[i]["FileName"].ToString().Length - (ds.Tables[0].Rows[i]["FileName"].ToString().IndexOf(".") + 1)) + ".png');background-repeat:no-repeat;background-position: right top;\">" +

                   "<div><div class='Link'><a href='javascript:openDoc(escape(\"" + (generalDir + ds.Tables[0].Rows[i]["FileName"].ToString()).Replace("\\", "~") + "\"));'>הצג</a></div>" +
                   "<div class='Link'><a href='javascript:EditDoc(\"" + ds.Tables[0].Rows[i]["DocManagementID"].ToString() + "\",escape(\"" + ds.Tables[0].Rows[i]["FileName"].ToString() +
                   "\"),escape(\"" + ds.Tables[0].Rows[i]["FileDesc"].ToString() + "\"),\"" + sbOc.ToString() + "\");'>ערוך</a></div></div>" +
                   "<div class='Desc'>" + ds.Tables[0].Rows[i]["FileDesc"].ToString() + "</div>");
                    sb.Append("<br/><div class='Oc'>");

                    if (sbIn.Length > 2)
                    {
                        sb.Append(sbIn.ToString().Substring(0, sbIn.Length - 2));
                    }

                    sb.Append("</div><div class='NameF'>" + ds.Tables[0].Rows[i]["FileName"].ToString() + "</div>");
                    sb.Append("</div>");
                }
            }

        }

        dDir.InnerHtml = sb.ToString();
    }

    protected void btnShowFile_Click(object sender, EventArgs e)
    {
        Context.Response.Clear();
        switch (hdnPre.Value.Split('.')[1].ToLower())
        {
            case "pdf":
                Context.Response.ContentType = "application/pdf";
                break;
            case "txt":
                Context.Response.ContentType = "text/plain";
                break;
            case "xls":
                Context.Response.ContentType = "application/vnd.ms-excel";
                break;
            case "xlsx":
                Context.Response.ContentType = "application/vnd.ms-excel";
                break;
            case "doc":
                Context.Response.ContentType = "application/msword";
                break;
            case "docx":
                Context.Response.ContentType = "application/msword";
                break;
            case "ppt":
                Context.Response.ContentType = "application/vnd.ms-powerpoint";
                break;
            case "pptx":
                Context.Response.ContentType = "application/vnd.openxmlformats-officedocument.presentationml.presentation";
                break;
            case "png":
                Context.Response.ContentType = "image/png";
                break;
            case "jpg":
                Context.Response.ContentType = "image/jpeg";
                break;
        }
        byte[] file = File.ReadAllBytes(Server.UrlDecode(hdnDoc.Value).Replace("~", "\\"));
        Context.Response.AddHeader("content-disposition", "attachment;    filename=file." + hdnPre.Value.Split('.')[1]);
        Context.Response.AddHeader("File-Name", "file." + hdnPre.Value.Split('.')[1]);
        Context.Response.AddHeader("content-length", file.Length.ToString());
        Context.Response.BinaryWrite(file);
        Context.Response.Flush();
        Context.Response.End();
    }
}