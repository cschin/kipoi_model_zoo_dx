#!/anaconda3/bin/python
"""
generate_kipoi_notebook

Usage:
   generate_kipoi_notebook <model_name> [<output_notebook_name>]


"""

import os
from docopt import docopt
import kipoi
import pprint
from kipoi.cli.env import conda_env_name
import nbformat as nbf


def get_dataloader_descr(model_name):
    dl_path = os.path.join(model_name, kipoi.get_model_descr(model_name).default_dataloader)
    return kipoi.get_dataloader_descr(dl_path)


def get_example_kwargs(model_name):
    """Get the example kwargs from the dataloader
    """
    dl = get_dataloader_descr(model_name)
    return dl.get_example_kwargs()


def get_batch_size(model_name, source):
    # HACK
    if source == "kipoi" and model_name == "Basenji":
        return 2
    else:
        return 4

# --------------------------------------------
# Python


# python specific snippets
def py_set_example_kwargs(model_name):
    example_kwargs = get_example_kwargs(model_name)
    return "\nkwargs = " + pprint.pformat(example_kwargs)



def py_snippet(model_name, source="kipoi", output_nb_name=None):
    """Generate the python code snippet
    """
    try:
        kw = get_example_kwargs(model_name)
    except Exception:
        kw = "Error"
    ctx = {"model_name": model_name,
           "example_kwargs": kw,
           "batch_size": get_batch_size(model_name, source)}

    nb = nbf.v4.new_notebook()

    text1 = "## Get the model: {model_name}".format(**ctx)
    code1 = ("import kipoi\n"
             "model = kipoi.get_model('{model_name}')".format(**ctx))

    nb["cells"].append( nbf.v4.new_markdown_cell(text1) )
    nb["cells"].append( nbf.v4.new_code_cell(code1) )

    text2 = "## Make a prediction for example files"
    code2 = "pred = model.pipeline.predict_example()"

    nb["cells"].append( nbf.v4.new_markdown_cell(text2) )
    nb["cells"].append( nbf.v4.new_code_cell(code2) )

    text3 = "## Use dataloader and model separately"
    code3 = ("# setup the example dataloader kwargs\n"
            "dl_kwargs = {example_kwargs}\n"
            "import os; os.chdir(os.path.expanduser('~/.kipoi/models/{model_name}'))\n"
            "# Get the dataloader and instantiate it\n"
            "dl = model.default_dataloader(**dl_kwargs)\n"
            "# get a batch iterator\n"
            "it = dl.batch_iter(batch_size={batch_size})\n"
            "# predict for a batch\n"
            "batch = next(it)\n"
            "model.predict_on_batch(batch['inputs'])\n".format(**ctx))

    nb["cells"].append( nbf.v4.new_markdown_cell(text3) )
    nb["cells"].append( nbf.v4.new_code_cell(code3) )

    text4 = "## Make predictions for custom files directly"
    code4 = """pred = model.pipeline.predict(dl_kwargs, batch_size={batch_size})""".format(**ctx)

    nb["cells"].append( nbf.v4.new_markdown_cell(text4) )
    nb["cells"].append( nbf.v4.new_code_cell(code4) )

    if output_nb_name is None:
        output_nb_name  = "model.ipynb"
    output_nb_name = output_nb_name.replace("/","_")
    nbf.write(nb, output_nb_name)

if __name__ == "__main__":
    args = docopt(__doc__, version='generate_kipoi_notebook')
    py_snippet(args["<model_name>"], output_nb_name=args["<output_notebook_name>"])
