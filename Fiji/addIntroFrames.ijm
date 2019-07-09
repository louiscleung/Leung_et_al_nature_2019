macro "addIntroFrames..." {
	//With new annotated thumbnail frame, we open both, duplicate the thumbnail, add to start of 
	//movie and then save out as an avi.
	
	//put both .tif and .avi in a folder and select it
	dir = getDirectory("Choose a Directory of AVIs...");
	firstFrameName = dir + "firstFrame.tif";
	list = getFileList(dir);
	open(firstFrameName);
	//Duplicate 19x to have 1 sec of the preview thumbnail
	selectWindow("firstFrame.tif");
	run("Duplicate Frame", "slice=1 number=19");
	//open the original avi
	for (i=0; i < list.length; i++) {
		if (endsWith(list[i], ".avi")) {
			name = list[i];
			avipath = dir + name;
			run("AVI...", "select=[avipath] use"); //select does its thing without the option menu
		}
	}
	//add thumbnail to beginning of avi
	selectWindow("firstFrame.tif");
	run("Concatenate...", "  title=[Concatenated Stacks] image1=firstFrame.tif image2=name image3=[-- None --]");
	//save out as avi at 20fps
	newName = "annotatedMovie.avi";
	newPath = dir + File.separator + newName;
	run("AVI... ", "compression=JPEG frame=20 save=[newPath]");
	close();
}