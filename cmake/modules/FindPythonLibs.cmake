# - Find python libraries
# This module finds if Python is installed and determines where the
# include files and libraries are. It also determines what the name of
# the library is. This code sets the following variables:
#
#  PYTHON_LIBRARIES     = path to the python library
#  PYTHON_INCLUDE_PATH  = path to where Python.h is found
#  PYTHON_DEBUG_LIBRARIES = path to the debug library
#  PYTHON_VERSION = version of python library
#
#  The user can set this variable to choose their preferred python 
#  version to be found:
#
#  PREFERRED_PYTHON_VERSION = preferred version of the python library 

INCLUDE(CMakeFindFrameworks)

IF(WIN32)
  FIND_LIBRARY(PYTHON_DEBUG_LIBRARY
    NAMES python26_d python25_d python24_d python23_d python22_d python21_d python20_d python
    PATHS
    [HKEY_LOCAL_MACHINE\\SOFTWARE\\Python\\PythonCore\\2.6\\InstallPath]/libs/Debug
    [HKEY_LOCAL_MACHINE\\SOFTWARE\\Python\\PythonCore\\2.6\\InstallPath]/libs
    [HKEY_LOCAL_MACHINE\\SOFTWARE\\Python\\PythonCore\\2.5\\InstallPath]/libs/Debug
    [HKEY_LOCAL_MACHINE\\SOFTWARE\\Python\\PythonCore\\2.5\\InstallPath]/libs
    [HKEY_LOCAL_MACHINE\\SOFTWARE\\Python\\PythonCore\\2.4\\InstallPath]/libs/Debug
    [HKEY_LOCAL_MACHINE\\SOFTWARE\\Python\\PythonCore\\2.4\\InstallPath]/libs
    [HKEY_LOCAL_MACHINE\\SOFTWARE\\Python\\PythonCore\\2.3\\InstallPath]/libs/Debug
    [HKEY_LOCAL_MACHINE\\SOFTWARE\\Python\\PythonCore\\2.3\\InstallPath]/libs
    [HKEY_LOCAL_MACHINE\\SOFTWARE\\Python\\PythonCore\\2.2\\InstallPath]/libs/Debug
    [HKEY_LOCAL_MACHINE\\SOFTWARE\\Python\\PythonCore\\2.2\\InstallPath]/libs
    [HKEY_LOCAL_MACHINE\\SOFTWARE\\Python\\PythonCore\\2.1\\InstallPath]/libs/Debug
    [HKEY_LOCAL_MACHINE\\SOFTWARE\\Python\\PythonCore\\2.1\\InstallPath]/libs
    [HKEY_LOCAL_MACHINE\\SOFTWARE\\Python\\PythonCore\\2.0\\InstallPath]/libs/Debug
    [HKEY_LOCAL_MACHINE\\SOFTWARE\\Python\\PythonCore\\2.0\\InstallPath]/libs
    [HKEY_LOCAL_MACHINE\\SOFTWARE\\Python\\PythonCore\\1.6\\InstallPath]/libs/Debug
    [HKEY_LOCAL_MACHINE\\SOFTWARE\\Python\\PythonCore\\1.6\\InstallPath]/libs
    [HKEY_LOCAL_MACHINE\\SOFTWARE\\Python\\PythonCore\\1.5\\InstallPath]/libs/Debug
    [HKEY_LOCAL_MACHINE\\SOFTWARE\\Python\\PythonCore\\1.5\\InstallPath]/libs
  )
ENDIF(WIN32)

FIND_LIBRARY(PYTHON_LIBRARY ${PREFERRED_PYTHON_VERSION}
  NAMES python26 python2.6
        python25 python2.5
        python24 python2.4
        python23 python2.3
        python22 python2.2
        python21 python2.1
        python20 python2.0
        python16 python1.6
        python15 python1.5

  PATHS
    [HKEY_LOCAL_MACHINE\\SOFTWARE\\Python\\PythonCore\\2.6\\InstallPath]/libs
    [HKEY_LOCAL_MACHINE\\SOFTWARE\\Python\\PythonCore\\2.5\\InstallPath]/libs
    [HKEY_LOCAL_MACHINE\\SOFTWARE\\Python\\PythonCore\\2.4\\InstallPath]/libs
    [HKEY_LOCAL_MACHINE\\SOFTWARE\\Python\\PythonCore\\2.3\\InstallPath]/libs
    [HKEY_LOCAL_MACHINE\\SOFTWARE\\Python\\PythonCore\\2.2\\InstallPath]/libs
    [HKEY_LOCAL_MACHINE\\SOFTWARE\\Python\\PythonCore\\2.1\\InstallPath]/libs
    [HKEY_LOCAL_MACHINE\\SOFTWARE\\Python\\PythonCore\\2.0\\InstallPath]/libs
    [HKEY_LOCAL_MACHINE\\SOFTWARE\\Python\\PythonCore\\1.6\\InstallPath]/libs
    [HKEY_LOCAL_MACHINE\\SOFTWARE\\Python\\PythonCore\\1.5\\InstallPath]/libs

  PATH_SUFFIXES
    python2.6/config
    python2.5/config
    python2.4/config
    python2.3/config
    python2.2/config
    python2.1/config
    python2.0/config
    python1.6/config
    python1.5/config
)
IF(PYTHON_LIBRARY)
message(STATUS "Found Python: ${PYTHON_LIBRARY}")
ENDIF(PYTHON_LIBRARY)

# Search for the python framework on Apple.
CMAKE_FIND_FRAMEWORKS(Python)
SET(PYTHON_FRAMEWORK_INCLUDES)
IF(Python_FRAMEWORKS)
  IF(NOT PYTHON_INCLUDE_PATH)
    FOREACH(version 2.6 2.5 2.4 2.3 2.2 2.1 2.0 1.6 1.5)
      FOREACH(dir ${Python_FRAMEWORKS})
        SET(PYTHON_FRAMEWORK_INCLUDES ${PYTHON_FRAMEWORK_INCLUDES}
          ${dir}/Versions/${version}/include/python${version})
      ENDFOREACH(dir)
    ENDFOREACH(version)
  ENDIF(NOT PYTHON_INCLUDE_PATH)
ENDIF(Python_FRAMEWORKS)

FIND_PATH(PYTHON_INCLUDE_PATH
  NAMES Python.h

  PATHS
    ${PYTHON_FRAMEWORK_INCLUDES}
    [HKEY_LOCAL_MACHINE\\SOFTWARE\\Python\\PythonCore\\2.6\\InstallPath]/include
    [HKEY_LOCAL_MACHINE\\SOFTWARE\\Python\\PythonCore\\2.5\\InstallPath]/include
    [HKEY_LOCAL_MACHINE\\SOFTWARE\\Python\\PythonCore\\2.4\\InstallPath]/include
    [HKEY_LOCAL_MACHINE\\SOFTWARE\\Python\\PythonCore\\2.3\\InstallPath]/include
    [HKEY_LOCAL_MACHINE\\SOFTWARE\\Python\\PythonCore\\2.2\\InstallPath]/include
    [HKEY_LOCAL_MACHINE\\SOFTWARE\\Python\\PythonCore\\2.1\\InstallPath]/include
    [HKEY_LOCAL_MACHINE\\SOFTWARE\\Python\\PythonCore\\2.0\\InstallPath]/include
    [HKEY_LOCAL_MACHINE\\SOFTWARE\\Python\\PythonCore\\1.6\\InstallPath]/include
    [HKEY_LOCAL_MACHINE\\SOFTWARE\\Python\\PythonCore\\1.5\\InstallPath]/include

  PATH_SUFFIXES
    ${PREFERRED_PYTHON_VERSION}
    python2.6
    python2.5
    python2.4
    python2.3
    python2.2
    python2.1
    python2.0
    python1.6
    python1.5
)

IF (WIN32)
  MARK_AS_ADVANCED(
    PYTHON_DEBUG_LIBRARY
    PYTHON_LIBRARY
    PYTHON_INCLUDE_PATH
  )
ENDIF(WIN32)


FIND_PROGRAM( PYTHON_EXECUTABLE NAMES ${PREFERRED_PYTHON_VERSION} python )

IF ( PYTHON_EXECUTABLE )
	EXEC_PROGRAM( ${PYTHON_EXECUTABLE} ARGS "-c \"import sys; print sys.version[:3]\"" OUTPUT_VARIABLE PYTHON_VERSION )
	STRING( REGEX REPLACE "[\r\n]" " " PYTHON_VERSION "${PYTHON_VERSION}"  )
ENDIF ( PYTHON_EXECUTABLE )

# Python Should be built and installed as a Framework on OSX
IF(Python_FRAMEWORKS)
  # If a framework has been selected for the include path,
  # make sure "-framework" is used to link it.
  IF("${PYTHON_INCLUDE_PATH}" MATCHES "Python\\.framework")
    SET(PYTHON_LIBRARY "")
    SET(PYTHON_DEBUG_LIBRARY "")
  ENDIF("${PYTHON_INCLUDE_PATH}" MATCHES "Python\\.framework")
  IF(NOT PYTHON_LIBRARY)
    SET (PYTHON_LIBRARY "-framework Python" CACHE FILEPATH "Python Framework" FORCE)
  ENDIF(NOT PYTHON_LIBRARY)
  IF(NOT PYTHON_DEBUG_LIBRARY)
    SET (PYTHON_DEBUG_LIBRARY "-framework Python" CACHE FILEPATH "Python Framework" FORCE)
  ENDIF(NOT PYTHON_DEBUG_LIBRARY)
ENDIF(Python_FRAMEWORKS)

# We use PYTHON_LIBRARY and PYTHON_DEBUG_LIBRARY for the cache entries
# because they are meant to specify the location of a single library.
# We now set the variables listed by the documentation for this
# module.
SET(PYTHON_LIBRARIES "${PYTHON_LIBRARY}")
SET(PYTHON_DEBUG_LIBRARIES "${PYTHON_DEBUG_LIBRARY}")

