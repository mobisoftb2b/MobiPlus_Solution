using MobiPlus.BusinessLogic.Layout.PageLayout;
using MobiPlus.Models.Attributes;
using MobiPlus.Models.Dashboard;
using MobiPlus.Models.Layout;
using System.Collections.Generic;
using System.Threading.Tasks;
using System.Web.Http;

namespace MobiPlus.Diplomat.WebAPI
{
    [RESTAuthorize]
    public class LayoutController : ApiController
    {
        [HttpPost]
        public async Task<IEnumerable<LayoutModel>> Layout_Reports2Form_SelectAll([FromBody]FilterParams inParams)
        {
            if (inParams == null) inParams = new FilterParams();
            return await new LayoutService().GetDataByID(inParams);
        }

        [HttpPost]
        public async Task<IEnumerable<FormModel>> Layout_MenuItems_SelectByUserAsync(FilterParams param)
        {
            if (param == null) param = new FilterParams();
            return await new LayoutService().Layout_MenuItems_SelectByUserAsync(param);
        }
        [HttpPost]
        public async Task<IEnumerable<TabModel>> Layout_TabsItems_SelectByUserAsync(FilterParams param)
        {
            if (param == null) param = new FilterParams();
            return await new LayoutService().Layout_TabsItems_SelectByUserAsync(param);
        }

    }
}
