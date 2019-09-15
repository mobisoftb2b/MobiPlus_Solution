using MobiPlus.Models.Dashboard;

namespace MobiPlus.Models.Layout
{
    public class ReportModel
    {
        public long? ReportID { get; set; }
        public string ReportName { get; set; }
        public int? ReportTypeID { get; set; }
        public string ReportTemplate { get; set; }
        public string ReportQuery { get; set; }
        public string ReportCaption { get; set; }
        public string Report_SP_Params { get; set; }
        public int? ReportDataSourceID { get; set; }
        public WidgetModel Widgets { get; set; }
    }
}
