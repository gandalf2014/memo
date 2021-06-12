# Anaconda
>`docker run -it --name=anaconda  -p 8888:8888 continuumio/anaconda3 /bin/bash -c "/opt/conda/bin/conda install jupyter -y --quiet && mkdir /opt/notebooks && /opt/conda/bin/jupyter notebook --notebook-dir=/opt/notebooks --ip='0.0.0.0' --port=8888 --no-browser --allow-root"`


> `docker run -it --restart always --name=my-conda2 -v / -p 8888:8888 anaconda:1.1.1 /bin/bash -c "/opt/conda/bin/jupyter notebook --notebook-dir=/opt/notebooks --ip='0.0.0.0' --port=8888 --no-browser --allow-root"`


>`jupyter notebook --notebook-dir=/opt/notebooks --ip='0.0.0.0' --allow-root --port=8888 --no-browser`



 >`jupyter notebook --notebook-dir=/opt/notebooks --ip='0.0.0.0' --allow-root --port=8888 --no-browser --kernel=scijava &&`



` conda update -n base -c defaults conda`

`conda install --channel https://conda.anaconda.org/conda-forge scijava-jupyter-kernel`


>`docker run --name anaconda-java --restart always -d -p 8888:8888 continuumio/anaconda3 /bin/bash -c "/opt/conda/bin/conda install jupyter -y --quiet && conda install -y --channel https://conda.anaconda.org/conda-forge scijava-jupyter-kernel && mkdir /opt/notebooks && /opt/conda/bin/jupyter notebook --notebook-dir=/opt/notebooks --ip='0.0.0.0' --port=8888 --no-browser --kernel=scijava"`


`jupyter kernelspec list`


>`http://192.168.33.15:8888/lab`




