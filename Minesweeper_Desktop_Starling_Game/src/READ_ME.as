package
{
	public class READ_ME
	{
		public function READ_ME()
		{
		}
	}
}


/**

 * 
 * 
 * 
 * 
 * READ_ME


Although I tend to not use many comments, I try to name variables and functions consistenly, 
 
always in camel case.

handler functions follow this style -> onTargetNameEventTypeClick

Instance variables begin with underscore (_). Local variables do not.

 

Strings, Numbers, ints, and uints don’t have any dataType suffix, but for many other variables 

you will see that I will concatonate a few letters to denote a certain data type. This is 
 
especially helpful in starling where you  sometimes have to use 5 or 6 different data types to show a 

moving image on the screen. The sound, image, and xml assets are in the assets folder. Texture packer 
 
publishes out to tpOutput, and I included the raw files for reference. 


One thing to note  about the 
 
swc is that all my sounds were .wav format so could not be embedded the same way as the spritesheets 

and xml.  Therefore, the sounds were brought into a library in Flash Professional and published as a 
 
swc. Flash Professional was used extensively for planning out popups and exporting the individual png 

images for texture packer. 
  
  
Here is a little info on the MVC structure. The Main Class, FsMinesweeper, extends a flash sprite. It
  
creates a model class which holds variabels to be chared among view classes, and als shares as a common point
  
for listenening to and sending messages between view classes. In the screens package are the classes that
  
correspond to each screen in the game. Although I don't make much use of the controller package here, I
 
tend to use what I call helpers. This could be thought of as controllers that have the stage passed to them. 
 
The minesweeper game itself is made with column arrays nested inside of row arrays. In the arrays
 
are instances of the CellDataObj class, which has a model layout and holds all the data essential to 
 
each cell.
 

For only having one week and being on my own I am pretty proud of this.  It is a playable minesweeper 

game with easy, medium, and hard. It contains sounds and movieclips. I actually enjoyed using starling. It 
 
becomes intuitive once you learn the api for doing common things. I have been testing on my computer 
 
and haven’t been able to test on mobile yet, but I am really excited to see how far 
 
the mobile as3 games can be pushed with starling. One note about the load time – on my computer it takes 

a considerable amount of seconds for the swf to load. I had been simply trying to just make the game and not 
 
optimize the game. Therefore, I load basically everything when the swf is launched. You could get clever 
 
about when you load different things, but I think a better choice is probably just to make an interesting 
 
waiting screen in the beginning while the game loads. Then you won’t have to worry about things not yet 
 
being loaded, and it is a  smooth experience moving throughout the game. I did not want to start messing 
 
with the native stage because I wanted to keep it a "fully starling project”. Anyway, this should run 
 
bug free in debug mode. Please let me know if you have trouble opening or compiling it. It was written 
 
in Flash Builder 4.7 . I’ll just ending by saying how badly I want to be a programmer at Fresh Planet. 
 
From the little that I know it seems the team is an experienced group of very competent developers. I want 
 
to contribute to awesome games. I am coachable and willing to learn new things, but I also already have 
 
lots of actionscript and coding experience and am capable of making great things. 

Thanks,
Jim Lynch


 * 
 * 
 * 
 * 
 * 
 * 
 * 
 **/