using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

public partial class Pages_Admin_Numerators : PageBaseCls
{
    public string colNames = "";
    public string colModel = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (SessionGroupID != "4" && SessionGroupID != "3")//not admin
            {
                Response.Redirect("../Usr/Home.aspx");
            }
            init();
        }
    }
    private void init()
    {
         //['#', 'שם', 'שאילתה', 'סוג שאילתה', 'פרמטרים', 'כותרת', 'סוג גרף'],
        //  { name: 'GraphName', index: 'GraphName', width: 142.725, sorttype: 'text', align: 'right', editable: true },
        //{ name: 'TaskUserOrder', index: "TaskUserOrder", type: 'float', sorttype: 'float', width: GetWidth(3), align: 'center', formatter: function (cellValue, option) { return '<input onblur=\"SaveUserOrder(this.value,' + option.rowId + ');\" type="text" style=\"text-align:center;width:30px;\" size="7" name="txtBox" id="txt_' + option.rowId + '" value="' + cellValue + '"/>'; } },
        MainService.MobiPlusWS wr = new MainService.MobiPlusWS();
        DataTable dt = wr.GetNumeratorsCols(ConStrings.DicAllConStrings[SessionProjectName]);
        if (dt != null)
        {
            colNames = "[";
            colModel = "[";
            for (int i = 0; i < dt.Columns.Count; i++)
            {
                colNames += "'<div class=\"dColName\">" + dt.Columns[i].ColumnName + "</div>',";
                colModel += "{ name: '" + dt.Columns[i].ColumnName + "', index: '" + dt.Columns[i].ColumnName + "', type: 'text', sorttype: 'text', width:90, align: 'center', formatter: function (cellValue, option) { return '<div onclick=\"ShowTXT(" + i.ToString() + ",this.innerText,' + option.rowId + ',&quot;" + dt.Columns[i].ColumnName + "&quot;);\" style=\"text-align:right;width:90px;\" name=\"txtBox\" id=\"txt_" + i.ToString() + "_' + option.rowId + '\" >' + cellValue + '</div>'} },";
            }

            if (colNames.Length > 2)
            {
                colNames = colNames.Substring(0, colNames.Length-1);
                colModel = colModel.Substring(0, colModel.Length - 1);
            }
            colNames += "]";
            colModel+="]";
            //colModel
        }
    }
}