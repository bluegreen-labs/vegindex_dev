# PhenoCam data processing pipeline

## Directory structure

Below is the structure for this project.

```
├── README.md               <- This includes general information on the project
|                              
├── LICENSE                 <- The AGPLv3 LICENSE FILE
│
├── environment.yml         <- The requirements file for reproducing the analysis environment
|
├── Dockerfile              <- Docker install routine for a virtual environment
│
└── data/archive            <- Topmost image archive folder
    |
    ├── site_info.csv       <- Basic information for every site in the archive
    │
    ├── sitename            <- Site based folder name containing all image data 
    |   |        
    |   ├── ROI             <- Regions of interest
    |   | 
    |   ├── images          <- PhenoCam images
    |   | 
    |   └── ...
    |
    └── ... [more sites]
```

## Setup

Two ways of creating reproducible environments are provided, the general Conda environment and an isolated Docker environment based on a Conda base image.

> [!WARNING]
> It is adviced to work in isolated Docker environments in order to ensure reproducibility, future online deployments, but first and foremost security of your computer system. Pip and to a lesser degree Conda and their python environments are a known malware vector. Although the framework we present vets the loaded library we can not assure the safety of all dependencies created downstream. The use of the local non-containerized setup is therefore not recommended.

### Conda

To create an environment which is consistent use the environment file after installing Miniconda.

```bash
conda env create -f environment.yml
```

Activate the working environment using:

```bash
conda activate vegindex
```

### Docker

The dockerfile included provides a Conda environment ([see here for docker install instructions](https://docs.docker.com/engine/install/)).
You can build this docker image using the below command. This will download all required
python components and packages, while safeguarding (sandboxing) your system
from `pip` based [security issues](https://www.bleepingcomputer.com/news/security/pypi-suspends-new-user-registration-to-block-malware-campaign/). Once build locally no further downloads 
will be required.

```
# In the main project directory run
docker build -f Dockerfile -t vegindex .
```

To spin up a docker image using:

```
docker run -it -v ./data/archive:/data/archive vegindex
```

This will give you a terminal with access to a working python environment. Although the processing is isolated (sandboxed) the virtual machine will have full access to the linked directory. Note that any destructive actions, e.g. (re)moving files, will be reflected outside the virtual machine. In short, although there is some protection against mallware, the setup does not prevent the corruption of your image archive. Before processing a whole archive it is best to test the integrity of the workflow on the included demo data.

## Use

For one-of processing you can use the linux environment as per instruction on the `vegindex` documentation site. However, when data arrives continuously it is best to setup processing at set intervals. The included script `process_vegindex.sh` steps through all required processing scripts of the `vegindex` package to update the whole archive. Note, this script does not include the management of the files. The management of incoming data into appropriate directories should be handled separately from the processing routine.

You can either call this script on the command line, manually, or rely on a timed cron job to process the data at set intervals. The latter is preferred for ease of use and consistency.

For example, if you want to run the script at 8:00h in the morning you can specify a cron job as such (when using the conda environment):

```
0 8 * * * /location/of/script/process_vegindex.sh
```

When using the docker image (the preferred method) you can use:

```
0 8 * * * docker run --rm vegindex -v ./data/archive:/data/archive /process_vegindex.sh
```
```








