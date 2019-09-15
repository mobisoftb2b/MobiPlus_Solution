using Mvc_5_Empty_Template1.Infrastructure;

namespace Mvc_5_Empty_Template1.App_Start
{
    public class FilterConfig
    {
        public static void Configure(System.Web.Mvc.GlobalFilterCollection filters)
        {
            filters.Add(new HandleErrorAttribute());
        }
    }
}
