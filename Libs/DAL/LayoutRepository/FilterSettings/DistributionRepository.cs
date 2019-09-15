using DAL.Common;
using MobiPlus.Models.Common;
using MobiPlus.Models.Common.FilterModel;
using MobiPlus.Models.Dashboard;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DAL.LayoutRepository.FilterSettings
{
    public class DistributionRepository: BaseRepository, IFilterRepository<DistributionModel, FilterParams>
    {
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

        public async Task<IEnumerable<DistributionModel>> GetDataByID(FilterParams param)
        {
            return await Task.Run(() => Layout_Filter_DistributionCenter(param));
        }

        private IEnumerable<DistributionModel> Layout_Filter_DistributionCenter(FilterParams inParams)
        {
            var result = new List<DistributionModel>();
            try
            {
                using (var context = new MobiPlusWebDiplomatEntities())
                {
                    result = context.Layout_Filter_DistributionCenter(inParams.CountryID, (int?)inParams.UserID, inParams.LanguageID)
                        .Select(a => new DistributionModel
                        {
                            DistrID = a.DistributionCenterID,
                            DistributionCenterDesc = a.DistributionCenterName
                        }).ToList();
                }

            }
            catch (Exception ex)
            {
            }
            return result;
        }

    }
}
