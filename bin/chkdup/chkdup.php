#!/usr/bin/php
<?php
# ------------------------------------
# sources.list Checker 0.01-Beta
# ------------------------------------
# Done By Mubarak Alrashidi (DeaDSouL)
# Wednesday, March 16 2011 - 22:06:08
# ------------------------------------
# On Ubuntu Lucid 10.04 + vim
# ------------------------------------



# ------------------------------------------------------------------------------
// Setting variables
$path     = (string) '/etc/apt/';
$src      = (string) $path . 'sources.list';
$bkp      = (string) $src . '.bkp.' . date( 'Y-m-d_G-i-s', time() );
// Don't chage anything below this line, unless you know what you're doing
$repos    = (int) 0; // total repositories
$arepo    = (int) 0; // active repositories
$irepo    = (int) 0; // inactive repositories
$drepo    = (int) 0; // duplicated repositories
$rrepo    = array(); // removed repositories
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
// Getting the contents of the sources.list
if ( ! file_exists( $src ) )
{
  die( "\"$src\" Does not exist\n" );
}

if ( function_exists( 'file_get_contents' ) )
{
	$content = file_get_contents( $src );
}
else
{
  if ( ! $fp = @fopen( $src, 'r' ) )
  {
    die( "Could not open \"$src\"\n" );
  }

  flock( $fp, LOCK_SH );

  $content = '';
  if ( filesize( $src ) > 0 )
  {
  	$content =& fread( $fp, filesize( $src ) );
  }

  flock( $fp, LOCK_UN );
  fclose( $fp );
  unset( $fp );
}
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
// Writing the backup file
if ( ! $fp = @fopen( $bkp, 'wb' ) )
{
  die( "Could not take a backup..\nExiting now\n" );
}

flock($fp, LOCK_EX);
fwrite($fp, $content);
flock($fp, LOCK_UN);
fclose($fp);
unset( $fp );
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
// Checking the sources & Generating the statistics
$content_arr = explode( "\n", $content );
$lines = count( $content_arr );
foreach( $content_arr as $line_num => $line_content )
{
  // If the line is empty
  if ( $line_content == '' 
    OR $line_content == "\n" )
  {
    $content_new[$line_num] = $line_content;
    continue;
  }
  // If the line is commented
  if ( $line_content[0] == '#' )
  {
    if ( //substr_count( $line_content, ' ' ) >= 4
      //AND substr_count( $line_content, ' ' ) <= 7
      //AND (
        strstr( $line_content, 'deb http://' )
        OR strstr( $line_content, 'deb-src http://' )
        OR strstr( $line_content, 'deb https://' )
        OR strstr( $line_content, 'deb-src https://' )
        OR strstr( $line_content, 'deb ftp://' )
        OR strstr( $line_content, 'deb-src ftp://' )
        OR strstr( $line_content, 'deb ftps://' )
        OR strstr( $line_content, 'deb-src ftps://' )
      //)
    )
    {
      $repos++;
      $irepo++;
    }
    continue;
  }
  // The line holds a repository
  $repos_arr[$line_num] = $line_content;
  $repos++;
  $arepo++;
}
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
// Preparing the repositories to be filtered
$unique_repos = array_unique( $repos_arr );
$repos_old  = count( $repos_arr );
$repos_new  = count( $unique_repos );
$drepo      = $repos_old - $repos_new;
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
// Removing the duplicated repositories, if there is any
if ( $drepo > 0 )
{
  $rrepo = array_diff_assoc( $repos_arr, $unique_repos );
  $content_arr_new = $content_arr;
  if ( ! empty( $rrepo ) AND count( $rrepo ) > 0 )
  {
    $removed_log = "Line:\t\t Repositories:\n";
    foreach ( $rrepo as $k => $v )
    {
      $content_arr_new[$k] = '##### Removed ##### ' . $content_arr_new[$k];
      $removed_log .= "$k\t\t $v\n";
    }
  }
}
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
// Updating the sources.list
if ( $drepo > 0 )
{
  if ( ! $fp = @fopen( $src, 'wb' ) )
  {
    die( "Could not update \"$src\"..\nExiting now\n" );
  }

  flock($fp, LOCK_EX);
  foreach ( $content_arr_new as $line )
  {
    fwrite($fp, "$line\n");
  }
  flock($fp, LOCK_UN);
  fclose($fp);
  unset( $fp );
}
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
// Printing the output
echo `clear`;
echo "------------------------------------\n";
echo "sources.list Checker 0.01-Beta\n";
echo "Done By Mubarak Alrashidi (DeaDSouL)\n";
echo "------------------------------------\n";
echo "Total Lines:\t\t\t $lines\n";
echo "Total Repositories:\t\t $repos\n";
echo "Active Repositories:\t\t $arepo\n";
echo "Inactive Repositories:\t\t $irepo\n";
echo "Duplicated Repositories:\t $drepo\n";
echo "------------------------------------\n";
echo ( isset( $removed_log ) ? $removed_log."------------------------------------\n" : '' );
echo "To un-do this, check the backup:\n\"$bkp\"\n";
# ------------------------------------------------------------------------------

die("\n");
?>

