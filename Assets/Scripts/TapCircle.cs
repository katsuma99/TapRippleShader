using UnityEngine;
using System.Collections;

[RequireComponent(typeof(SpriteRenderer))]
[RequireComponent(typeof(Collider2D))]
public class TapCircle : MonoBehaviour
{
    SpriteRenderer mSpriteRenderer;
    Collider2D mCircleCollider;

    void Awake()
    {
        mSpriteRenderer = transform.GetComponent<SpriteRenderer>();
        mCircleCollider = transform.GetComponent<Collider2D>();
    }

    void Start()
    {
        Invoke("unenabledTrigger", 0.05f);

        mSpriteRenderer.material.SetFloat("_StartTime", Time.time);

        float animationTime = mSpriteRenderer.material.GetFloat("_AnimationTime");
        float destroyTime = animationTime;
        destroyTime -= mSpriteRenderer.material.GetFloat("_StartWidth") * animationTime;
        destroyTime += mSpriteRenderer.material.GetFloat("_Width") * animationTime;
        Destroy(transform.gameObject, destroyTime);
    }

    public void unenabledTrigger()
    {
        mCircleCollider.enabled = false;
    }

    public void OnTriggerEnter2D(Collider2D collider)
    {
        //タップしたオブジェクト : collider

        //-----------------処理-----------------//

    }
}