using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

public partial class Pages_Usr_GridView : PageBaseCls
{
    public string colModel = "";
    public string colNames = "";
    public string Caption = "";
    public string GridName = "";
    public double GridWidth = 0;
    public string GridParameters = "";

    public string colModelMD = "";
    public string colNamesMD = "";
    public string CaptionMD = "";
    public string GridNameMD = "";
    public double GridWidthMD = 0;
    public string GridParametersMD = "";
    public int Rows = 10;
    public int RowsModel = 10;
    public string strID = "";

    public string strAgentID = "";
    public string strDate = "";

    public string strGridColID = "0";

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            try
            {
                if (Session["isWinWidth"] == null || (Session["isWinWidth"] != null && (bool)Session["isWinWidth"]) == false)
                {
                    ScriptManager.RegisterClientScriptBlock(this.Page, typeof(Page), "Reload", "DoStartWin();", true);
                    Session["isWinWidth"] = true;
                    return;
                }

                init();

                Session["isWinWidth"] = false;
                strID = Request.QueryString["ID"].ToString();
            }
            catch (Exception)
            {
            }
        }
    }
    private void init()
    {
        if (Session["DocWidth"] == null)
        {
            ScriptManager.RegisterClientScriptBlock(this.Page, typeof(Page), "Reload", "DoStart();", true);
            return;
        }
        

        if (Request.QueryString["GridName"] == null)
            return;

        GridName = Request.QueryString["GridName"].ToString();
        MainService.MobiPlusWS wr = new MainService.MobiPlusWS();
        DataSet ds = wr.GetGridDataNew(GridName, ConStrings.DicAllConStrings[SessionProjectName]);

        if (ds != null && ds.Tables.Count > 1 && ds.Tables[0].Rows.Count > 0)
        {
            Caption = ds.Tables[0].Rows[0]["GridCaption"].ToString();
            Rows = Convert.ToInt32(ds.Tables[0].Rows[0]["Rows"].ToString());
            GridWidth = (Convert.ToDouble(Session["DocWidth"].ToString()) / 2) - 15;

            colNames = "[";
            for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
            {
                //GridWidth += Convert.ToDouble(ds.Tables[0].Rows[i]["ColWidth"].ToString());

                colModel += "{ name: '" + ds.Tables[0].Rows[i]["ColName"].ToString().Trim() + "', index: " + "'" + ds.Tables[0].Rows[i]["ColName"].ToString().Trim() + "', width: " + (GridWidth * Convert.ToDouble(ds.Tables[0].Rows[i]["ColWidth"].ToString())/100) +
                    ", sorttype: '" + ds.Tables[0].Rows[i]["ColType"].ToString() + "', align: '" + ds.Tables[0].Rows[i]["ColAlignment"].ToString() + "',";
                colModel += " editable: true,";

                if (Convert.ToDouble(ds.Tables[0].Rows[i]["ColWidth"].ToString()) == 0)
                    colModel += " hidden: true,";

                if (ds.Tables[0].Rows[i]["ColType"].ToString() == "password")
                    colModel += "formatter: PassFormatter, stype: 'password',";
                else if (ds.Tables[0].Rows[i]["ColType"].ToString() == "date")
                    colModel += "formatter: 'date', sorttype: 'date', formatoptions: { srcformat: 'ISO8601Long', newformat: 'd/m/Y', defaultValue: null},";
                else if (ds.Tables[0].Rows[i]["ColType"].ToString() == "float" && ds.Tables[0].Rows[i]["ColPromt"].ToString() != "#")
                    colModel += "formatter: FloatFormatter, stype: 'float',";
                else if (ds.Tables[0].Rows[i]["ColType"].ToString() == "percent")
                    colModel += "formatter: PercentFormatter, stype: 'float',";
                else if (ds.Tables[0].Rows[i]["ColType"].ToString() == "TextDesigned")
                    colModel += "formatter: TextDesignedFormatter, stype: 'text',";
                else if (ds.Tables[0].Rows[i]["ColType"].ToString() == "int" && ds.Tables[0].Rows[i]["ColPromt"].ToString() != "#")
                    colModel += "formatter: NumbersFormatter, stype: 'int',";

                colModel = colModel.Substring(0, colModel.Length - 1);
                colModel += "},";

                colNames += "'" + ds.Tables[0].Rows[i]["ColPromt"].ToString() + "'";
                if (i != ds.Tables[0].Rows.Count - 1)
                    colNames += ",";

                if (ds.Tables[0].Rows[i]["ColName"].ToString().IndexOf("AgentID")>-1)
                {
                    strAgentID = ds.Tables[0].Rows[i]["ColName"].ToString();
                }

                if (ds.Tables[0].Rows[i]["ColName"].ToString().IndexOf("Date") > -1)
                {
                    strDate = ds.Tables[0].Rows[i]["ColName"].ToString();
                }
            }
            colModel = colModel.Substring(0, colModel.Length-1);
            colNames += "]";
            colNamesMD = "[";

            if (ds.Tables[1].Rows.Count > 0)
            {
                CaptionMD = ds.Tables[1].Rows[0]["GridCaption"].ToString();

                GridWidthMD = 0;

                GridNameMD = ds.Tables[1].Rows[0]["GridName"].ToString();

                RowsModel = Convert.ToInt32(ds.Tables[1].Rows[0]["Rows"].ToString());

                
                for (int i = 0; i < ds.Tables[1].Rows.Count; i++)
                {
                    GridWidthMD += Convert.ToDouble(ds.Tables[1].Rows[i]["ColWidth"].ToString());
                    //ColAlignment
                    colModelMD += "{ name: '" + ds.Tables[1].Rows[i]["ColName"].ToString().Trim() + "', index: " + "'" + ds.Tables[1].Rows[i]["ColName"].ToString().Trim() + "', width: " + (GridWidth * Convert.ToDouble(ds.Tables[1].Rows[i]["ColWidth"].ToString()) / 100) + 
                        ", sorttype: '" + ds.Tables[1].Rows[i]["ColType"].ToString() + "', align: '" + ds.Tables[1].Rows[i]["ColAlignment"].ToString() + "',";
                    colModelMD += " editable: true,";

                    if (Convert.ToDouble(ds.Tables[1].Rows[i]["ColWidth"].ToString()) == 0)
                        colModelMD += " hidden: true,";

                    if (ds.Tables[1].Rows[i]["ColType"].ToString() == "password")
                        colModelMD += "formatter: PassFormatter, stype: 'password',";
                    else if (ds.Tables[1].Rows[i]["ColType"].ToString() == "date")
                        colModelMD += "formatter: 'date', sorttype: 'date', formatoptions: { srcformat: 'ISO8601Long', newformat: 'd/m/Y', defaultValue: null},";

                    colModelMD = colModelMD.Substring(0, colModelMD.Length - 1);
                    colModelMD += "},";

                    colNamesMD += "'" + ds.Tables[1].Rows[i]["ColPromt"].ToString() + "'";
                    if (i != ds.Tables[1].Rows.Count - 1)
                        colNamesMD += ",";

                    if (ds.Tables[1].Rows[i]["ColPromt"].ToString() == "#")
                        strGridColID = ds.Tables[1].Rows[i]["ColName"].ToString().Trim();
                }

                
            }
        }
        //colModelMD = colModelMD.Substring(0, colModelMD.Length - 1);
        colNamesMD += "]";
        GridParameters += Request.QueryString["GridParameters"].ToString();
        GridParametersMD += Request.QueryString["GridParameters"].ToString();

        if (Request.QueryString["iDate"] != null && Request.QueryString["AgentID"] != null)
        {
            string iDate = Request.QueryString["iDate"].ToString();
            string AgentID = Request.QueryString["AgentID"].ToString();
            GridParameters = "Date:" + iDate + ";" + "AgentID:" + AgentID;
            GridParametersMD = "Date:" + iDate + ";" + "AgentID:" + AgentID;
            //if (Request.QueryString["GridParameters"].ToString() != "")
            //{
            //    GridParameters = Request.QueryString["GridParameters"].ToString() + ";Date:" + iDate + ";" + "AgentID:" + AgentID;
            //    GridParametersMD = Request.QueryString["GridParameters"].ToString() + ";Date:" + iDate + ";" + "AgentID:" + AgentID;
            //}
            //else
            //{
            //    GridParameters = "Date:" + iDate + ";" + "AgentID:" + AgentID;
            //    GridParametersMD = "Date:" + iDate + ";" + "AgentID:" + AgentID;
            //}

            
        }
    }
}
