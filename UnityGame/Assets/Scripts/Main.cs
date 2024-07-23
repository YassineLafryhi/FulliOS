using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Main : MonoBehaviour
{
    private GameObject pyramid;
    private GameObject cameraObject;

    void Start()
    {
        pyramid = CreatePyramid();

        pyramid.GetComponent<MeshRenderer>().material.color = Color.yellow;

        cameraObject = new GameObject("MainCamera");
        Camera camera = cameraObject.AddComponent<Camera>();
        cameraObject.transform.position = new Vector3(0, 1, -3);
        cameraObject.transform.LookAt(pyramid.transform);

        GameObject lightGameObject = new GameObject("Directional Light");
        Light lightComp = lightGameObject.AddComponent<Light>();
        lightComp.type = LightType.Directional;
        lightGameObject.transform.rotation = Quaternion.Euler(50, -30, 0);
    }

    void Update()
    {
        pyramid.transform.Rotate(new Vector3(0, 50, 0) * Time.deltaTime);
    }

    private GameObject CreatePyramid()
    {
        GameObject pyramid = new GameObject("Pyramid");

        MeshFilter meshFilter = pyramid.AddComponent<MeshFilter>();
        MeshRenderer meshRenderer = pyramid.AddComponent<MeshRenderer>();

        Mesh mesh = new Mesh();

        Vector3[] vertices = new Vector3[]
        {
            new Vector3(0, 1, 0),
            new Vector3(-0.5f, 0, 0.5f),
            new Vector3(0.5f, 0, 0.5f),
            new Vector3(0.5f, 0, -0.5f),
            new Vector3(-0.5f, 0, -0.5f)
        };

        int[] triangles = new int[]
        {
            0, 1, 2,
            0, 2, 3,
            0, 3, 4,
            0, 4, 1,
            1, 4, 3,
            1, 3, 2
        };

        mesh.vertices = vertices;
        mesh.triangles = triangles;

        mesh.RecalculateNormals();

        meshFilter.mesh = mesh;

        return pyramid;
    }
}
