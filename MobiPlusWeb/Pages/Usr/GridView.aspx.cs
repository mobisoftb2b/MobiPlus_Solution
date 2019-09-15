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

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            init();
        }
    }
    private void init()
    {
        if (Request.QueryString["GridName"] == null)
            return;

        GridName = Request.QueryString["GridName"].ToString();
        MainService.MobiPlusWS wr = new MainService.MobiPlusWS();
        DataSet ds = wr.GetGridData(GridName, ConStrings.DicAllConStrings[SessionProjectName]);

        if (ds != null && ds.Tables.Count > 1 && ds.Tables[1].Rows.Count > 0)
        {
            Caption = ds.Tables[1].Rows[0]["GridCaption"].ToString();
            
            GridWidth=0;

            colNames="[";
            for (int i = 0; i < ds.Tables[1].Rows.Count; i++)
            {
                GridWidth += Convert.ToDouble(ds.Tables[1].Rows[i]["ColWidth"].ToString());
                colModel += "{ name: '" + ds.Tables[1].Rows[i]["ColNameGrid"].ToString() + "', index: " + "'" + ds.Tables[1].Rows[i]["ColNameGrid"].ToString() + "', width: " + ds.Tables[1].Rows[i]["ColWidth"].ToString() + ", sorttype: '" + ds.Tables[1].Rows[i]["ColType"].ToString() + "', ";
                colModel += " editable: true,";

                if (ds.Tables[1].Rows[i]["ColType"].ToString()=="Password")
                    colModel += "formatter: PassFormatter, stype: 'password',";
                else if (ds.Tables[1].Rows[i]["ColType"].ToString() == "Date")
                    colModel += "formatter: 'date', sorttype: 'date', formatoptions: { srcformat: 'ISO8601Long', newformat: 'd/m/Y', defaultValue: null},";

                colModel += "},";

                colNames += "'" + ds.Tables[1].Rows[i]["ColPromt"].ToString() + "'";
                if(i != ds.Tables[1].Rows.Count-1)
                    colNames += ",";
            }
            colNames+="]";
        }
    }
}