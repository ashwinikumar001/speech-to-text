**Prerequisites** For Docker Installations, please Refer to "https://docs.docker.com/engine/installation/"  

*Steps to setup the application: _(First time run)_ *

    Step 1: Go to the project root directory.
    
    Step 2: Build the docker image using the command below
        $ docker build -t dopeddude/stt .
    
    Step 3: Create the docker container
        $ docker create -it -h dopeddude-host --name dopeddude-stt dopeddude/stt:latest
        
    Step 4: Start the docker container
        $ docker start dopeddude-stt
    
    Step 5: Let's go inside the container to start some services (Use either of the following command) 
        $ docker exec -it dopeddude-stt bash -l
        $ docker exec -it dopeddude-stt fish
    
    Step 6: Test a raw file with pocketsphinx to test the output
        $ node stt.js '../deps/pocketsphinx/test/data/goforward.raw'
    
*Steps to test the different audio files:*

	Step 1: Copy the sample audio file
        $ docker cp <src-audio-file> dopeddude-stt:/<destination-path-to-file>
    
    Step 2: Start the docker container
        $ docker start dopeddude-stt
    
    Step 3: Let's go inside the container 
        $ docker exec -it dopeddude-stt bash -l
    
    Step 4: Test a raw file with pocketsphinx to test the output
        $ node stt.js '<path-to-copied-file>'
        