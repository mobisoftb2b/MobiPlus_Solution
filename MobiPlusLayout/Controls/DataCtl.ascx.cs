using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Web.UI.HtmlControls;

public partial class Controls_DataCtl : CtlBaseCls
{
    public string CtlDataSPName
    {
        get
        {
            if (ViewState["CtlDataSPName"] == null)
                ViewState["CtlDataSPName"] = "None";
            return ViewState["CtlDataSPName"].ToString();
        }
        set
        {
            ViewState["CtlDataSPName"] = value;
        }
    }
    public string[] arrNames
    {
        get
        {
            if (ViewState["arrNames"] == null)
                ViewState["arrNames"] = "None";
            return (string[])ViewState["arrNames"];
        }
        set
        {
            ViewState["arrNames"] = value;
        }
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            init();
        }
    }
    private void init()
    {
        MPLayoutService wr = new MPLayoutService();
        DataSet ds = wr.RunSPForCtl(CtlDataSPName, "", "mtnsLayout");

        if (ds != null)
        {
            HtmlGenericControl dynTBL = new HtmlGenericControl("table");
            dynTBL.Style["width"] = "100%";
            for (int i = 0; i < ds.Tables.Count; i++)
            {
                
                if (i == 0)
                {
                    arrNames = ds.Tables[0].Rows[0]["Names"].ToString().Split(',');
                    for (int y = 0; y < arrNames.Length; y++)
                    {
                        HtmlGenericControl dynTRM = new HtmlGenericControl("tr");
                        HtmlGenericControl dynTDM = new HtmlGenericControl("td");
                        HtmlGenericControl dynTDData = new HtmlGenericControl("td");
                        
                        dynTDM.Attributes["class"] = "CtlDataMainItem";
                        dynTDM.InnerHtml = arrNames[y];
                        dynTDM.Attributes["onclick"] = "ShowSection('" + arrNames[y] + "');";

                        dynTDData.Attributes["class"] = "CtlDataItem";
                        dynTDData.InnerHtml = " ";
                        //dynTDData.Attributes["onclick"] = "ShowSection('" + arrNames[y] + "');";

                        dynTRM.Controls.Add(dynTDM);
                        dynTRM.Controls.Add(dynTDData);
                        dynTBL.Controls.Add(dynTRM);
                    }
                    
                }
                else
                {
                }
               
            }
            divControl.Controls.Add(dynTBL);
        }
    }
}