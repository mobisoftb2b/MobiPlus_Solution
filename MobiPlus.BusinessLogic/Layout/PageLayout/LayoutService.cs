using DAL.LayoutRepository.Layout;
using MobiPlus.Models.Common.FilterModel;
using MobiPlus.Models.Dashboard;
using MobiPlus.Models.Layout;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace MobiPlus.BusinessLogic.Layout.PageLayout
{
    public class LayoutService : IFilterRepository<LayoutModel, FilterParams>
    {
        protected LayoutRepository _repository;
        public LayoutService()
        {
            this._repository = new LayoutRepository();
        }

        public async Task<IEnumerable<LayoutModel>> GetDataByID(FilterParams param)
        {
            return await this._repository.GetDataByID(param);
        }

        public async Task<IEnumerable<FormModel>> Layout_MenuItems_SelectByUserAsync(FilterParams param)
        {
            return await _repository.Layout_MenuItems_SelectByUserAsync(param);
        }

        #region IDisposable Support
        private bool _disposedValue = false;

        protected virtual void Dispose(bool disposing)
        {
            if (!_disposedValue)
            {
                if (disposing)
                {
                    // TODO: dispose managed state (managed objects).
                }

                _disposedValue = true;
            }
        }

        public void Dispose()
        {
            Dispose(true);
        }



        #endregion

        public async Task<IEnumerable<TabModel>> Layout_TabsItems_SelectByUserAsync(FilterParams filterParams)
        {
            return await _repository.Layout_TabsItems_SelectByUserAsync(filterParams);
        }
    }
}
