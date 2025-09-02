#!/bin/bash

# activate environment if not running from
# bash shell CLI / docker direct call to script
if [[ "${CONDA_DEFAULT_ENV}" != "vegindex" ]]; then
  source activate vegindex
fi

# if the default directory does not exist
# assume it is set by the global variable
if [ ! -d "/data/archive" ]; then
  archive_path=${PHENOCAM_ARCHIVE_DIR}
else
  archive_path="/data/archive"
fi

# double check if the global variable
# based path exists as well
if [ ! -d "${archive_path}" ]; then
  echo "image archive path does not exist!"
  echo " -- check if /data/archive is mounted"
  echo " -- or the environment variable"
  echo " -- PHENOCAM_ARCHIVE_DIR is set"
  exit 1
fi

# list all sites (full directories)
site_paths=`ls -d ${archive_path}/*/`

# processing all sites
for site_path in $site_paths; do

   # get site name
   site=`basename $site_path`

   # list all ROIs for a site
   rois=`ls ${archive_path}/${site}/ROI/*roi.csv | cut -d"_" -f2-3`
   
   # loop over all ROIs and process
   # or update the data
   for roi in $rois; do
   
        # generate or update image time series
        # processing all images
        if [ -f "${archive_path}/${site}/ROI/${site}_${roi}_roistats.csv" ]; then
          update_roi_timeseries $site $roi        
        else
          generate_roi_timeseries $site $roi
        fi
   
        # generate or update 1 and 3-day summaries
        # based upon the raw data
        if [ -f "${archive_path}/${site}/ROI/${site}_${roi}_3day.csv" ]; then            
          update_summary_timeseries -p 3 $site $roi
        else            
          generate_summary_timeseries -p 3 $site $roi
        fi
        
        if [ -f "${archive_path}/${site}/ROI/${site}_${roi}_1day.csv" ]; then
          update_summary_timeseries -p 1 $site $roi  
        else
          generate_summary_timeseries -p 1 $site $roi
        fi
        
        # update permissions of (output) files in
        # the ROI directory
        chmod a+rw `ls ${archive_path}/${site}/ROI/*.csv`
   
        # for IR image processing I refer to the readthedocs
        # manual https://python-vegindex.readthedocs.io/en/latest/usage.html#processing-ir-images
   
   done
done
