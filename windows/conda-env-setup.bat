rem set GLOTZER_PKGS="hoomd freud signac signac-flow gsd fresnel"
set "GLOTZER_PKGS=signac signac-flow signac-dashboard"
set "SCIPY_PKGS=numpy pandas scipy matplotlib sympy seaborn statsmodels tqdm cython"
set "ML_PKGS=scikit-learn keras tensorflow"
set "NB_PKGS=ipython ipykernel jupyterlab"
set "DOC_PKGS=sphinx sphinx_rtd_theme nbsphinx"
set "DEV_PKGS=flake8 autopep8 bumpversion nose ddt tbb tbb-devel coverage"
set "ALL_PKGS=%GLOTZER_PKGS% %SCIPY_PKGS% %ML_PKGS% %NB_PKGS% %DOC_PKGS% %DEV_PKGS%"

rem Set up channels
cmd /C conda config --add channels conda-forge

if not exist "%USERPROFILE%\Miniconda3\envs\glotzer" (
echo "Creating conda environment."
cmd /C conda create --yes --name glotzer
)

cmd /C conda install %ALL_PKGS%
rem cmd /C conda install --name glotzer %ALL_PKGS%
