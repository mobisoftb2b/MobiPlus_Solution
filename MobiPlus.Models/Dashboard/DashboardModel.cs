using MobiPlus.Models.GridDefinition;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MobiPlus.Models.Dashboard
{
   public class DashboardModel
    {
        public IEnumerable<LayoutDetails> LayoutDetail { get; set; }
        public IEnumerable<WidgetModel> WidgetModels { get; set; }
        public IEnumerable<GridSettings> GridSettings { get; set; }

    }
}
