#define PI 3.145

float4 Float4(float x,float y, float z)
{
	float4 f;
	f.x = x;
	f.y = y;
	f.z = z;
	f.w = 1.0f;
	return f;
}

float rand(__global float* randVector , int index)
{
  return (float)(randVector[index%5000]) ;
}

float minDiedralAngle(float4 v0, float4 v1, float4 v2, float4 v3)
{
	float d[6];
	float x21,y21,z21, x31,y31,z31, x41,y41,z41, x32,y32,z32, x42,y42,z42, x43,y43,z43 ,
		x123,y123,z123,o123, x124,y124,z124,o124, x134,y134,z134,o134, x234,y234,z234,o234    ;

	x21  = (float)( v1.x - v0.x);
	y21  = (float)(v1.y - v0.y);
	z21  = (float)(v1.z - v0.z);

	x31  = (float)(v2.x - v0.x);
	y31  = (float)(v2.y - v0.y);
	z31  = (float)(v2.z - v0.z);

	x41  = (float)(v3.x - v0.x);
	y41  = (float)(v3.y - v0.y);
	z41  = (float)(v3.z - v0.z);

	x32  = (float)(v2.x - v1.x);
	y32  = (float)(v2.y - v1.y);
	z32  = (float)(v2.z - v1.z);

	x42  = (float)(v3.x - v1.x);
	y42  = (float)(v3.y - v1.y);
	z42  = (float)(v3.z - v1.z);

	x43  = (float)(v3.x - v2.x);
	y43  = (float)(v3.y - v2.y);
	z43  = (float)(v3.z - v2.z);

	x123 = y21*z31 - z21*y31;
	y123 = z21*x31 - x21*z31;
	z123 = x21*y31 - y21*x31;
	o123 = sqrt(x123*x123 + y123*y123 + z123*z123);

	x124 = y41*z21 - z41*y21;
	y124 = z41*x21 - x41*z21;
	z124 = x41*y21 - y41*x21;
	o124 = sqrt(x124*x124 + y124*y124 + z124*z124);

	x134 = y31*z41 - z31*y41;
	y134 = z31*x41 - x31*z41;
	z134 = x31*y41 - y31*x41;
	o134 = sqrt(x134*x134 + y134*y134 + z134*z134);

	x234 = y42*z32 - z42*y32;
	y234 = z42*x32 - x42*z32;
	z234 = x42*y32 - y42*x32;
	o234 = sqrt(x234*x234 + y234*y234 + z234*z234);

	d[0] = (x123*x124 + y123*y124 + z123*z124)/(o123*o124);
	d[1] = (x123*x134 + y123*y134 + z123*z134)/(o123*o134);
	d[2] = (x134*x124 + y134*y124 + z134*z124)/(o134*o124);
	d[3] = (x123*x234 + y123*y234 + z123*z234)/(o123*o234);
	d[4] = (x124*x234 + y124*y234 + z124*z234)/(o124*o234);
	d[5] = (x134*x234 + y134*y234 + z134*z234)/(o134*o234);
	if (d[0] < -1.0)  d[0] = -1.0;
	if (d[0] >  1.0)  d[0] =  1.0;
	if (d[1] < -1.0)  d[1] = -1.0;
	if (d[1] >  1.0)  d[1] =  1.0;
	if (d[2] < -1.0)  d[2] = -1.0;
	if (d[2] >  1.0)  d[2] =  1.0;
	if (d[3] < -1.0)  d[3] = -1.0;
	if (d[3] >  1.0)  d[3] =  1.0;
	if (d[4] < -1.0)  d[4] = -1.0;
	if (d[4] >  1.0)  d[4] =  1.0;
	if (d[5] < -1.0)  d[5] = -1.0;
	if (d[5] >  1.0)  d[5] =  1.0;

	float mD = 500000;	
   	
	for (int i=0;i <6 ; i++)
	{
	    d[i] =-acos(d[i]);		
		if (d[i] <mD) mD = d[i];		
	}
	
	return (PI+mD)*180/PI;
}

float MaxValue(float *Numbers,  int Count)
{
	float Maximum = Numbers[0];
	for(int i = 1; i < Count; i++)
		if( Maximum < Numbers[i] )
			Maximum = Numbers[i];
	return Maximum;
}

float distanceD(float4 Point1, float4 Point2)
{
	float dx,dy,dz;

	dx = Point2.x - Point1.x;
	dy = Point2.y - Point1.y;
	dz = Point2.z - Point1.z;
	return  sqrt(dx * dx + dy * dy + dz * dz);
}

float MinValue(const float *Numbers, const int Count)
{
	float Minimun = Numbers[0];
	for(int i = 1; i < Count; i++)
		if( Minimun > Numbers[i] )
			Minimun = Numbers[i];
	return Minimun;
}

float getminEdgeLength(float4 v0, float4 v1, float4 v2, float4 v3) 
{
	float distances[6] = {distanceD(v0 , v1) , 
		distanceD(v0 , v2) ,
		distanceD(v0 , v3) ,
		distanceD(v1 , v2) ,
		distanceD(v1 , v3) ,
		distanceD(v2 , v3) };
	return MinValue(distances, 6);
}

float getmaxEdgeLength(float4 v0, float4 v1, float4 v2, float4 v3) 
{
	float distances[6] = {distanceD(v0 , v1) , 
		distanceD(v0 , v2) ,
		distanceD(v0 , v3) ,
		distanceD(v1 , v2) ,
		distanceD(v1 , v3) ,
		distanceD(v2 , v3) };
	return MaxValue(distances, 6);
}
float tetraVolume(float4 v0, float4 v1, float4 v2, float4 v3)
{
	float x21,y21,z21, x31,y31,z31, x41,y41,z41 ,  x123,y123,z123;


	x21  = v1.x - v0.x;
	y21  = v1.y - v0.y;
	z21  = v1.z - v0.z;

	x31  = v2.x - v0.x;
	y31  = v2.y - v0.y;
	z31  = v2.z - v0.z;

	x41  = v3.x - v0.x;
	y41  = v3.y - v0.y;
	z41  = v3.z - v0.z;

	x123 = y21*z31 - z21*y31;
	y123 = z21*x31 - x21*z31;
	z123 = x21*y31 - y21*x31;

	return (x123*x41 + y123*y41 + z123*z41) / 6;
}

__kernel void lpMeshSmoothKernel(__global int*  assignment,__global  int *neighbours,__global int* tetra,__global   float4* vertexPositions,
                                 __global  int* tetrapositions, float minExpectedQ, int mxIter, int subI, __global float* randVector)
{
  
     size_t x = get_global_id(0);
       int vertexID = assignment[x];
       if (vertexID<0) return ; 

	    int nproposals,iter;  
		float4 initialPos ,proposed;
		int hasNegative;
		int vList[100];
		int numN,tId,iv0,iv1,iv2,iv3;
		float minq,avgq ,minq2, avgq2 ,q,minVol,radius;

	    float4 v = vertexPositions[vertexID];	   
	    numN = 0;
	    // En W codifico si esta fijo
	    if (v.w< 0.0) return;
	   	   
	    float4 v0,v1,v2,v3;
	    // vList son los tetraedros vecinos 

	    for ( int j = 0; j<100 ; j++)
	    {
	      vList[j] = neighbours[vertexID*100+j];
		  if ( vList[j] >= 0)
		    numN++;		  
	    }

	   //calculo la calidad minima del set
		minq = 1000000.0;
		avgq = 0.0;
		radius = 0.0;
		hasNegative = 0;
		int j = 0;
		for (int j=0 ; j<numN ; j++)
		{
			tId = vList[j];			
			iv0 = tetrapositions[4*tId+0];
			iv1 = tetrapositions[4*tId+1];
			iv2 = tetrapositions[4*tId+2];
			iv3 = tetrapositions[4*tId+3];

			v0 = vertexPositions[iv0];
			v1 = vertexPositions[iv1];
			v2 = vertexPositions[iv2];
			v3 = vertexPositions[iv3];
			if (tetraVolume(v0,v1,v2,v3) < 0) hasNegative = 1;
          
			q = minDiedralAngle(v0,v1,v2,v3);
			minq =min(minq,q );
			avgq += q;
			radius += (getmaxEdgeLength(v0,v1,v2,v3) + getminEdgeLength(v0,v1,v2,v3))*0.5;			
		}
		
		

	     avgq = avgq /numN;
		 radius /=2*numN;
		 if (minq > minExpectedQ) return;

	   	//pruebo variando en un entorno
		initialPos =v;
		float randX, randY, randZ;
		bool found = false;
		
		for (iter = 0 ; iter<mxIter ; iter++)
		{
			for (nproposals = 0 ;nproposals<subI ;nproposals++)
			{
				randX =  rand(randVector,vertexID*iter*nproposals*3);
				randY =  rand(randVector,vertexID*iter*nproposals*3+1);
				randZ =  rand(randVector,vertexID*iter*nproposals*3+2);
				proposed = Float4( (randX-0.5f)*radius,(randY-0.5f)*radius,(randZ-0.5f)*radius) + initialPos ;
				
				minq2 = 1000000;
				avgq2 = 0;
				minVol = 100000000;
				for (j=0 ; j<numN ; j++)
				{	
					tId =vList[j] ;
					if (tId<0) break;
					iv0 = tetrapositions[4*tId+0];					
					iv1 = tetrapositions[4*tId+1];					
					iv2 = tetrapositions[4*tId+2];					
					iv3 = tetrapositions[4*tId+3];

					v0 = vertexPositions[iv0];
					v1 = vertexPositions[iv1];
					v2 = vertexPositions[iv2];
					v3 = vertexPositions[iv3];
					
					if (iv0 == vertexID) 
						v0 = proposed;
					else
					  if (iv1 == vertexID) 
						v1 = proposed;
					  else
						if (iv2 == vertexID) 
							v2 = proposed;
						else if (iv3 == vertexID) 
						   v3 = proposed;
						else
						{
							///error de acceso
							v0.w = 1;
							break;
						}
					
					q = minDiedralAngle(v0,v1,v2,v3);
					minq2 =min(minq2,q );
					avgq2 += q;
					minVol = min(minVol, tetraVolume(v0,v1,v2,v3));
				}

				if (minVol<0) continue;
				
				avgq2 = avgq2 /numN;
                if (minq2>minq)
				{					  
					    initialPos = proposed;
				   	    minq = minq2;
						found = true;
				
				}
				
			}
		}
		
		if (found)
		{
			vertexPositions[vertexID].x = initialPos.x;
			vertexPositions[vertexID].y = initialPos.y;
			vertexPositions[vertexID].z = initialPos.z;
			vertexPositions[vertexID].w = 1.0f;
		}
		else
		  vertexPositions[vertexID].w = 0.0f;
}