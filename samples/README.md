# samples

This folder contains Flex mobile samples.

## Getting Started

1. Read the [Instructions (Getting Started) section][1] in the Documentation for Developers.
2. Open Adobe Flash Builder, choose File -> Import Flash Builder Project.
3. Select Project folder, click Browse, and navigate to the downloaded "samples" folder.
    * Select the "mobile-shared-library-flex" project folder.
4. Open Adobe Flash Builder, choose File -> Import Flash Builder Project.
5. Select Project folder, click Browse, and navigate to the downloaded "samples" folder.
    * Select the "hello-map-listeners" project folder.
6. Add the API Library to the project through Project (required for all the projects except hello-world).
    * Go to Project -> Properties -> Flex Build Path -> Library Path -> Add SWC (and locate the "agslib-#.#-YYYY-MM-DD.swc").
    * Alternatively, copy the swc library to the libs folder under the "hello-map-listeners" project.
7. Run the application using a simulator or on a physical device. Using the Run Configurations (Run > Run Configuration) you can add a Mobile application and define the Launch method as appropriate.

*Target platform Apple iOS requires a Certificate and Provisioning file*, [Learn more about Apple iOS deployment][2].

For more information see the [Mobile applications with Flex][3] topic in the [API Concepts][4].

[1]: https://github.com/lheberlie/building-mobile-apps-flex/wiki
[2]: http://www.adobe.com/go/fb47_ios
[3]: http://resources.arcgis.com/en/help/flex-api/concepts/#/Mobile_applications_with_Flex/017p00000025000000/
[4]: http://resources.arcgis.com/en/help/flex-api/concepts/index.html
