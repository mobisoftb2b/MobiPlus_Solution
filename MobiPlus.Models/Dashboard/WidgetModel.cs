using System.Drawing;
using CodeFirstStoredProcs;

namespace MobiPlus.Models.Dashboard
{
    public class WidgetModel
    {
        public int? WidgetID { get; set; }
        public string Title { get; set; }
        public int? Plan { get; set; }
        public int? Done { get; set; }
        public int? Percent { get; set; }
        public string ChartColor { get; set; }
        public string TrackColor { get; set; }
        public string Value { get; set; }
        public string UpperText { get; set; }
        public string LowerText { get; set; }
        public string BGColor{ get; set; }
        public string SubBgColor { get; set; }
        public string IconName { get; set; }
        public string Color { get; set; }
        public int? RadialChartSize { get; set; }
        public string PlanDone { get; set; }
    }

    public class WidgetParams
    {
        [StoredProcAttributes.Name("WidgetID")]
        [StoredProcAttributes.ParameterType(System.Data.SqlDbType.Int)]
        public int? WidgetID { get; set; }

        [StoredProcAttributes.Name("CountryID")]
        [StoredProcAttributes.ParameterType(System.Data.SqlDbType.BigInt)]
        public long? CountryID { get; set; }

        [StoredProcAttributes.Name("DistrID")]
        [StoredProcAttributes.ParameterType(System.Data.SqlDbType.BigInt)]
        public long? DistrID { get; set; }

        [StoredProcAttributes.Name("AgentId")]
        [StoredProcAttributes.ParameterType(System.Data.SqlDbType.BigInt)]
        public long? AgentId { get; set; }

        [StoredProcAttributes.Name("FromDate")]
        [StoredProcAttributes.ParameterType(System.Data.SqlDbType.NVarChar)]
        public string FromDate { get; set; }

        [StoredProcAttributes.Name("ToDate")]
        [StoredProcAttributes.ParameterType(System.Data.SqlDbType.NVarChar)]
        public string ToDate { get; set; }

        public string ReportQuery { get; set; }
        public string Report_SP_Params { get; set; }
        public int? LanguageID { get; set; }

    }
}