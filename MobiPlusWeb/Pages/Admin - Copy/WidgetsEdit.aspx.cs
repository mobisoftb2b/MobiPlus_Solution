using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

public partial class Pages_Admin_GridsEdit : PageBaseCls
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

    public string strGridColID = "0";

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            init();
        }
    }
    private void init()
    {
        if (Session["DocWidth"] == null)
        {
            ScriptManager.RegisterClientScriptBlock(this.Page, typeof(Page), "Reload", "DoStart();", true);
            return;
        }


        MainService.MobiPlusWS wr = new MainService.MobiPlusWS();



        GridName = "GridWidgetsForEdit";

        DataSet ds = wr.GetGridDataNew(GridName, ConStrings.DicAllConStrings[SessionProjectName]);

        if (ds != null && ds.Tables.Count > 1 && ds.Tables[0].Rows.Count > 0)
        {
            Caption = ds.Tables[0].Rows[0]["GridCaption"].ToString();
            Rows = Convert.ToInt32(ds.Tables[0].Rows[0]["Rows"].ToString());
            GridWidth = 0;

            colNames = "[";
            for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
            {
                //GridWidth += Convert.ToDouble(ds.Tables[0].Rows[i]["ColWidth"].ToString());
                GridWidth = Convert.ToDouble(Session["DocWidth"].ToString()) / 2;
                //ColAlignment
                colModel += "{ name: '" + ds.Tables[0].Rows[i]["ColName"].ToString().Trim() + "', index: " + "'" + ds.Tables[0].Rows[i]["ColName"].ToString().Trim() + "', width: " + (GridWidth * Convert.ToDouble(ds.Tables[0].Rows[i]["ColWidth"].ToString()) / 100) +
                    ", sorttype: '" + ds.Tables[0].Rows[i]["ColType"].ToString() + "', align: '" + ds.Tables[0].Rows[i]["ColAlignment"].ToString() + "',";

                if (ds.Tables[0].Rows[i]["ColName"].ToString() != "widgetid")
                    colModel += " editable: true,";

                if (Convert.ToDouble(ds.Tables[0].Rows[i]["ColWidth"].ToString()) == 0)
                    colModel += " hidden: true,";

                if (ds.Tables[0].Rows[i]["ColType"].ToString() == "password")
                    colModel += "formatter: PassFormatter, stype: 'password',";
                else if (ds.Tables[0].Rows[i]["ColType"].ToString() == "date")
                    colModel += "formatter: 'date', sorttype: 'date', formatoptions: { srcformat: 'ISO8601Long', newformat: 'd/m/Y', defaultValue: null},";

                if (ds.Tables[0].Rows[i]["ColName"].ToString() == "GroupName")
                {
                    colModel += "edittype: 'select',editoptions:{ value: getGroupNames() }, editrules: { required: true },";

                }
                else if (ds.Tables[0].Rows[i]["ColName"].ToString() == "MasterDetailsGridID")
                {
                    colModel += "edittype: 'select',editoptions:{ value: getGrids() }, editrules: { required: true },";

                }
                colModel = colModel.Substring(0, colModel.Length - 1);
                colModel += "},";

                colNames += "'" + ds.Tables[0].Rows[i]["ColPromt"].ToString() + "'";
                if (i != ds.Tables[0].Rows.Count - 1)
                    colNames += ",";

                if (ds.Tables[0].Rows[i]["ColOpenWindowByGridID"].ToString() == "1")
                    strGridColID = ds.Tables[0].Rows[i]["ColName"].ToString().Trim();
            }
            colModel = colModel.Substring(0, colModel.Length - 1);
            colNames += "]";
            colNamesMD = "[";
            //if (ds.Tables[1].Rows.Count > 0)
            //{
            //    CaptionMD = ds.Tables[1].Rows[0]["GridCaption"].ToString();

            //    GridWidthMD = 0;

            //    GridNameMD = ds.Tables[1].Rows[0]["GridName"].ToString();

            //    RowsModel = Convert.ToInt32(ds.Tables[1].Rows[0]["Rows"].ToString());

            //    colNamesMD = "[";
            //    for (int i = 0; i < ds.Tables[1].Rows.Count; i++)
            //    {
            //        GridWidthMD += Convert.ToDouble(ds.Tables[1].Rows[i]["ColWidth"].ToString());
            //        //ColAlignment
            //        colModelMD += "{ name: '" + ds.Tables[1].Rows[i]["ColName"].ToString().Trim() + "', index: " + "'" + ds.Tables[1].Rows[i]["ColName"].ToString().Trim() + "', width: " + (GridWidth * Convert.ToDouble(ds.Tables[1].Rows[i]["ColWidth"].ToString()) / 100) +
            //            ", sorttype: '" + ds.Tables[1].Rows[i]["ColType"].ToString() + "', align: '" + ds.Tables[0].Rows[1]["ColAlignment"].ToString() + "',";

            //        if (ds.Tables[1].Rows[i]["ColName"].ToString() != "id" && ds.Tables[1].Rows[i]["ColName"].ToString() != "gridid")
            //            colModelMD += " editable: true,";

            //        if (Convert.ToDouble(ds.Tables[1].Rows[i]["ColWidth"].ToString()) == 0)
            //            colModelMD += " hidden: true,";

            //        if (ds.Tables[1].Rows[i]["ColType"].ToString() == "password")
            //            colModelMD += "formatter: PassFormatter, stype: 'password',";
            //        else if (ds.Tables[1].Rows[i]["ColType"].ToString() == "date")
            //            colModelMD += "formatter: 'date', sorttype: 'date', formatoptions: { srcformat: 'ISO8601Long', newformat: 'd/m/Y', defaultValue: null},";

            //        if (ds.Tables[1].Rows[i]["ColName"].ToString() == "gridid")
            //            colModelMD += "edittype: 'select',editoptions:{ value: getGrids() }, editrules: { required: true },";
            //        else if (ds.Tables[1].Rows[i]["ColName"].ToString() == "colalignment")
            //            colModelMD += "edittype: 'select',editoptions:{ value: getAlignment() }, editrules: { required: true },";
            //        else if (ds.Tables[1].Rows[i]["ColName"].ToString() == "coltype")
            //            colModelMD += "edittype: 'select',editoptions:{ value: getTypes() }, editrules: { required: true },";

            //        colModelMD += "},";

            //        colNamesMD += "'" + ds.Tables[1].Rows[i]["ColPromt"].ToString() + "'";
            //        if (i != ds.Tables[1].Rows.Count - 1)
            //            colNamesMD += ",";


            //    }

                colNamesMD += "]";
            }
        //}
        //GridParameters += Request.QueryString["GridParameters"].ToString();
        // GridParametersMD += Request.QueryString["GridParameters"].ToString();
    }
}
