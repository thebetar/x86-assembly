#include <stdio.h>
#include <stdlib.h>

extern int find_markers(unsigned char *bitmap, unsigned int *x_pos, unsigned int *y_pos);

int main(int argc, char *argv[])
{
    printf("\nThis program reads a bitmap and finds the markers in it.\n\n");

    if (argc != 2)
    {
        printf("No file name provided");
        return -1;
    }

    printf("File name: %s\n", argv[1]);

    FILE *file = fopen(argv[1], "rb");

    if (file == NULL)
    {
        printf("Error: Could not open file.\n");
        return -1;
    }

    fseek(file, 0, SEEK_END);
    long file_size = ftell(file);
    rewind(file);

    unsigned char *bitmap = malloc(file_size);

    if (bitmap == NULL)
    {
        printf("Error: Could not allocate memory.\n");
        return -1;
    }

    printf("Reading file of size %ld bytes.\n\n", file_size);

    fread(bitmap, 1, file_size, file);

    // 50 is the maximum number of markers
    unsigned int *x_pos = malloc(50 * sizeof(unsigned int));
    unsigned int *y_pos = malloc(50 * sizeof(unsigned int));

    int markers = find_markers(bitmap, x_pos, y_pos);

    if (markers == -1)
    {
        printf("Error: Could not find markers, check filetype.\n");
        return 1;
    }

    printf("Found %d markers:\n", markers);

    // Get header size
    fseek(file, 22, SEEK_SET);

    int img_height;
    fread(&img_height, 4, 1, file);

    for (int i = 0; i < markers; i++)
    {
        printf("  - Shape %d found on point: (%d | %d) \n", i + 1, x_pos[i], img_height - y_pos[i] - 1);
    }

    fclose(file);
}