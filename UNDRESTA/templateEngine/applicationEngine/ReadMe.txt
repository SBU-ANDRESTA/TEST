This folder contains python scripts which generate necessary .sh files
For application side of our system, we need some .sh files include:
	- create_node_**.sh
	- download.sh

For generating these files, we wrote some python scripts which use Quik templating engine 

* download_engine.py:
	use download_template.sh to generate download.sh file by using application.xml
* sw_script_engine.py:
	use sw_script_template to generate create_node_**.sh files in a hw_scripts folder by using application.xml
* application_side_engine.py:
	use both python scripts to generate needed files all