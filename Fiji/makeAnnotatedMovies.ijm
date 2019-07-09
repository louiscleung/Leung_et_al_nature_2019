//Load an image sequence into Fiji...

//choose Fire LUT
run("Apply LUT", "stack");

//Adjust brightness and contrast such that background is black.

//despeckle the movie to "smoothen it"
run("Despeckle", "stack");

//Add calibratuion bar
run("Calibration Bar...", "location=[Lower Left] fill=None label=White number=4 decimal=0 font=12 zoom=1 overlay");

//Add a timestamper - here is it 2hz.
run("Time Stamper", "starting=0 interval=0.50 x=2 y=15 font=12 decimal=0 anti-aliased or=sec");

//save as avi
run("AVI... ", "compression=JPEG frame=20 save=[ADDPATHNAMEHERE]");
close();
